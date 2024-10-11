#!/bin/bash

#
# This script establishes symlinks in order to be able to easily work with all centralized files and folders.
# All relevant files and folders are centralized in the ~/mydata folder.
#

# No trailing slashes here!
HOME_FOLDER=$HOME
ORIGIN_HOME_FOLDER=$HOME/mydata

# -------------------------------------------------------

function add_trailing_slash_if_needed {
    local the_path=$1
    local length=${#the_path}
    local last_char=${the_path:length-1:1}
    [[ $last_char != "/" ]] && the_path="$the_path/"; :
    echo $the_path
}

#
# Replaces a file or folder (the target) in its old location (dest_folder)
# with a symlink pointing to the new location (origin_folder) where the
# original file or folder (the target) now resides.
#
# All targets in the old destinations will be backed up with timestamped
# file endings.
#
# origin_folder ($1):  The folder where the target (the actual file or
#                      folder) resides.
# target ($2):         The file or folder a symlink is created for (ie,
#                      the symlink points to this one).
#                      Must not have trailing slashes!
# dest_folder ($3):    The destination folder where the symlink is
#                      created in. From here the target is referenced.
# as_sudo ($4):        Whether or not to act as sudo. 0=no, 1=yes.
#                      Some dest_folders, like e.g. the file system
#                      root (/), require sudo in order to create a
#                      symlink in it.
# force_creating ($5): Whether or not to force creating. 0=no, 1=yes.
#                      If 0 then only create the symlink if the target
#                      in the origin folder exists.
#                      If 1 then create a symlink even if there is no
#                      target to symlink to, resulting in a broken
#                      symlink.
#
function create_symlink {
    local origin_folder="${1}"
    local target="${2}"
    local dest_folder="${3}"
    local as_sudo="${4}"
    local force_creating="${5}"

    # Add trailing slashes if not existent:
    origin_folder=$(add_trailing_slash_if_needed "${origin_folder}")
    dest_folder=$(add_trailing_slash_if_needed "${dest_folder}")

    local fq_path_to_origin_target="${origin_folder}${target}"
    local fq_path_to_dest_target="${dest_folder}${target}"

    local backup_timestamp=$(date +%Y-%m-%d_%H-%M-%S)

    local backup_msg="Backing up ${fq_path_to_dest_target}"
    local ln_msg="Creating symlink to ${fq_path_to_origin_target} in ${dest_folder} (as ${fq_path_to_dest_target})"
    local delete_symlink_msg="Removing symlink ${fq_path_to_dest_target}"
    local delete_all_backups_msg="Deleting all backups for ${fq_path_to_dest_target}"

    local do_create_symlink=1

    local sudo_name="$(id -un)"
    if [ $as_sudo -eq 1 ]; then
        sudo_name="root"
    fi

    echo ""
    echo "- Acting as ${sudo_name}"

    if [ $DELETE_ALL_SYMLINKS -eq 1 ]; then
        echo "${delete_symlink_msg}"
        if [ -L "${fq_path_to_dest_target}" ]; then
            sudo -u ${sudo_name} rm "${fq_path_to_dest_target}"
        fi
        do_create_symlink=0
    fi

    if [ $DELETE_ALL_BACKUPS -eq 1 ]; then
        echo "${delete_all_backups_msg}"
        sudo -u ${sudo_name} rm -rf "${fq_path_to_dest_target}".setup_symlinks_backup_*
        do_create_symlink=0
    fi

    if [ $do_create_symlink -eq 1 ]; then
        if [ -e "${fq_path_to_origin_target}" ] || [ $force_creating -eq 1 ]; then
            # Only if target in the origin folder exists or $force_creating is true:

            if [[ -e "${fq_path_to_dest_target}" || -L "${fq_path_to_dest_target}" && ! -e "${fq_path_to_dest_target}" ]]; then
                # If target exists or is broken link
                echo "${backup_msg}"
                sudo -u ${sudo_name} mv "${fq_path_to_dest_target}" "${fq_path_to_dest_target}.setup_symlinks_backup_${backup_timestamp}"
            else
                echo "Skipping b/c nothing to do: ${backup_msg}"
            fi

            echo "${ln_msg}"
            sudo -u ${sudo_name} ln -s "${fq_path_to_origin_target}" "${fq_path_to_dest_target}"
        else
            echo "Skipping: ${backup_msg}"
            echo "Skipping: ${ln_msg}"
        fi
    fi

    echo "- Finished acting as ${sudo_name}"
}

function confirm {
    local question="$1"
    local exit_msg="$2"
    local response="N"

    read -r -p "$question" response
    case $response in
        [yY])
            # Okay
            ;;
        *)
            # Catch all -> treat as "no".
            echo $exit_msg
            echo "Exiting. Bye."
            exit 0
            ;;
    esac
}

function append_to_file {
    local line="$1"
    local target_file="$2"

    if [ ! -f "$target_file" ] ; then
        echo "File $target_file does not exist. Creating."
        touch "$2"
    fi

    if grep -q "^$line$" "$target_file" ; then
        echo "Nothing to do for $target_file   ... skipping."
        return 0
    else
        echo "Appending '$line' to $target_file"
        echo -e "\n# Sourcing custom file\n$line" >> $target_file
    fi
}

function echo_heading {
    local heading="$1"
    echo "----> $heading"
}

# -------------------------------------------------------

function start {
    local operating_system=$(uname -o)
    local run_mode="${1}"

    echo "HOME_FOLDER:        $HOME_FOLDER"
    echo "ORIGIN_HOME_FOLDER: $ORIGIN_HOME_FOLDER"
    echo ""

    local DELETE_ALL_BACKUPS=0
    local DELETE_ALL_SYMLINKS=0

    local do_create_symlinks=0

    if [[ "${run_mode}" == "--delete-all-backups" ]]; then
        confirm "Do you really want to delete (aka destroy forever) all created backups (could be an original directory)? [y/N]" "Okay. Nothing to do."
        DELETE_ALL_BACKUPS=1
    elif [[ "${run_mode}" == "-d" ]]; then
        confirm "Do you really want to remove all symlinks? [y/N]" "Okay. Nothing to do."
        DELETE_ALL_SYMLINKS=1
    else
        do_create_symlinks=1
    fi

    # -------------------------------------------------------

    if [ $do_create_symlinks -eq 1 ]; then
        local rc_file=".bashrc"
        if [[ "$operating_system" == 'Darwin' ]]; then
            rc_file=".zshrc"
        fi
        if [[ "$operating_system" == 'GNU/Linux' ]]; then
            if [ -f "$HOME_FOLDER/.zshrc" ] ; then
                rc_file=".zshrc"
            fi
        fi

        echo_heading "Sourcing custom shell files"
        append_to_file ". $ORIGIN_HOME_FOLDER/dotfiles/${rc_file}_custom" $HOME_FOLDER/$rc_file
        echo_heading "Done sourcing"
    fi

    # -------------------------------------------------------
    # SETTING UP THE SYMLINKS
    #

    ###
    #
    # Do not centralize the following files/folders:
    #
    # ~/.npm - contains cache files only. It can be safely deleted.
    # ~/.gradle - contains cache files only. It can be safely deleted.
    # ~/.config/Code/User/ - vscode is synced via the vscode settings sync feature and GitHub
    #
    ###

    ###
    #
    # Usage:
    # create_symlink <source parent folder> <target folder> <dest parent folder> <as_sudo 0|1> <force_creating 0|1>
    #
    # Example:
    # create_symlink $ORIGIN_HOME_FOLDER/.local/share/      fonts               $HOME_FOLDER/.local/share                   0 0
    #
    ###

    create_symlink $ORIGIN_HOME_FOLDER/dotfiles/            .gitconfig          $HOME_FOLDER                                0 0
    create_symlink $ORIGIN_HOME_FOLDER/dotfiles/            .npmrc              $HOME_FOLDER                                0 0
    create_symlink $ORIGIN_HOME_FOLDER                      bin                 $HOME_FOLDER                                0 0
    create_symlink $ORIGIN_HOME_FOLDER                      dotfiles            $HOME_FOLDER                                0 0
    create_symlink $ORIGIN_HOME_FOLDER                      tmp                 $HOME_FOLDER                                0 0
    create_symlink $ORIGIN_HOME_FOLDER                      todo                $HOME_FOLDER                                0 0
    create_symlink $ORIGIN_HOME_FOLDER                      .aws                $HOME_FOLDER                                0 0
    create_symlink $ORIGIN_HOME_FOLDER                      .cert               $HOME_FOLDER                                0 0
    create_symlink $ORIGIN_HOME_FOLDER                      .gnupg              $HOME_FOLDER                                0 0
    create_symlink $ORIGIN_HOME_FOLDER                      .kube               $HOME_FOLDER                                0 0
    create_symlink $ORIGIN_HOME_FOLDER                      .ssh                $HOME_FOLDER                                0 0

    create_symlink $ORIGIN_HOME_FOLDER/.config              locale.conf         $HOME_FOLDER/.config                        0 0
    create_symlink $ORIGIN_HOME_FOLDER/.config/go           env                 $HOME_FOLDER/.config/go                     0 0
    create_symlink $ORIGIN_HOME_FOLDER/.config/gcloud       configurations      $HOME_FOLDER/.config/gcloud                 0 0
    create_symlink $ORIGIN_HOME_FOLDER/.config/gcloud       active_config       $HOME_FOLDER/.config/gcloud                 0 0

    #create_symlink $ORIGIN_HOME_FOLDER/.config/            mimeapps.list       $HOME_FOLDER/.config                        0 0
    # Next line because some apps still write into deprecated .local/share/applications/mimeapps.list
    #create_symlink $ORIGIN_HOME_FOLDER/.config/            mimeapps.list       $HOME_FOLDER/.local/share/applications      0 0

    # Not needed:
    #create_symlink $ORIGIN_HOME_FOLDER/.local/share/       Steam               $HOME_FOLDER/.local/share                   0 0
    #create_symlink $ORIGIN_HOME_FOLDER                     docs                $HOME_FOLDER/Documents                      0 0
    #create_symlink $ORIGIN_HOME_FOLDER                     images              $HOME_FOLDER/Pictures                       0 0
    #create_symlink $ORIGIN_HOME_FOLDER                     videos              $HOME_FOLDER/Videos                         0 0
    #create_symlink $ORIGIN_HOME_FOLDER                     audio               $HOME_FOLDER/Music                          0 0

    #
    # end - SETTING UP THE SYMLINKS
    # -------------------------------------------------------

    echo ""
    echo "Done setting up symlinks."
    echo ""
    echo "After checking the just created backups consider deleting them (be cautious!) by executing setup_symlinks.sh --delete-all-backups"
}

start $1
