#!/usr/bin/env bash
#{{{ Bash settings
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
set -o xtrace
#
#}}}
# "$OSTYPE" can be used to check the type of OS (???)
# Types: darwin, linux,
"$OSTYPE"
#
# Use a Package Manager
# Install with Brew (Mac)
# $ brew cask install vscodium
# Install with Chocolatey (Windows)
# $ choco install vscodium
# Install with Scoop (Windows)
# $ scoop bucket add extras scoop install vscodium
function main() {
    osWhat
}

function osWhat() {
local currentOS
currentOS=$(egrep "^ID=" /usr/lib/os-release | awk --field-separator "=" '{print $2}')

if [[ "${currentOS}" =~ '(arch|manjaro|arcolinux)' ]];then

    printf "%s\n" "This is Arch Linux based... I guess"
    if [[ -x $(which aura 2>&1) ]];then
        sudo aura -A vscodium
    elif[[ -x $(which yay 2>&1) ]]
        sudo yay -S vscodium
    elif[[ -x $(which trizen 2>&1) ]]
        sudo trizen -S vscodium
    else
        printf "%s\n%s\n" "No AUR capable package manager found or not implemente here." "Can choose one from https://wiki.archlinux.org/index.php/AUR_helpers. Look in Pacman wrappers"
    fi

elif [[ "${currentOS}" =~ '(debian|ubuntu|parrot|linuxmint)' ]];then

    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
    echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list

    printf "%s\n" "This is Debian based... it looks like"
    if [[ -x $(which apt 2>&1) ]];then
        # Debian / Ubuntu (deb package):
        sudo apt update && sudo apt install codium
    elif[[ -x $(which apt-get 2>&1) ]]
        sudo yay -S vscodium
    else
        printf "%s\n" "Could not find a package manager. (??)"
    fi

elif [[ "${currentOS}" =~ '(fedora|centos|opensuse)' ]];then

    sudo rpm --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
    if [[ currentOS = 'fedora' ]];then
        printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" |sudo tee -a /etc/yum.repos.d/vscodium.repo
        sudo dnf install codium
    elif [[ currentOS = 'centos' ]];then
        printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" |sudo tee -a /etc/yum.repos.d/vscodium.repo
        sudo dnf install codium
    elif [[ currentOS = 'opensuse' ]];then
        printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" |sudo tee -a /etc/zypp/repos.d/vscodium.repo
        sudo zypper in codium
    else
        printf "%s" "Could not identify."
    fi
elif [[ "${currentOS}" =~ '(nixos)' ]];then
    # Nix(OS)
    nix-env -iA nixpkgs.vscodium
else
    printf "%s %s\n" "Your OS ID was not implemented or not found." "${currentOS}"
fi

}

#{{{ Ignite
main "${@}"
#}}} Ignited
