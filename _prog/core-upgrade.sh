

# WARNING: No production use. May be untested.
# ATTENTION: This 'upgrade' functionality is a non-essential and intentionally less than comprehensive development tool to reduce cycle time for 'ubDistBuild' by cautiously and quickly upgrading only repositories, etc, with still rapidly developing essential functionality.

# https://unix.stackexchange.com/questions/486760/is-it-possible-to-allow-multiple-ssh-host-keys-for-the-same-ip
#_chroot sudo -n --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN -u user bash -c 'cd /home/user/core/infrastructure/ubDistFetch ; /home/user/ubDistBuild/ubiquitous_bash.sh _gitBest pull'
#_chroot sudo -n --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN -u user bash -c 'cd /home/user/core/infrastructure/ubDistFetch ; /home/user/ubDistBuild/ubiquitous_bash.sh _gitBest submodule update --recursive'
#_chroot sudo -n -u user bash -c 'cd /home/user/core/infrastructure/ubDistFetch ; ./ubiquitous_bash.sh _upgrade'

# WARNING: ATTENTION: As this function is MANUALLY used for very non-routine development for which fast cycle time is imperative, fast diagnosis of any issues is similarly critical, and there is no need to output exclusively machine readable information. Further, shell script compatible AI LLM 'augment' model is normally available. Extensive diagnostic output messaging is absolutely needed.
# 1) Progress bars, or other log file pollution, is reduced or eliminated.
# 2) Diagnostic output consistency is not dependent on color .
# 3) Absence of upgradable repository, etc, fail - does not proceed from undefined state.
# 4) Fail fast, diagnose fast. Short, human readable amount of diagnostic output, machine readable exit status stops CI/etc job on any fail.

# "$1" ~= /home/user/core/.../repoName
# "$2" ~= HEAD (optional)
_upgrade_repository() {
    _messageNormal 'init: _upgrade_repository: '"$1"' '"$2"
    local functionEntryPWD
    functionEntryPWD="$PWD"

    local currentRepoDir
    currentRepoDir="$1"

    local currentCheckout
    currentCheckout="$2"
    [[ "$currentCheckout" == "" ]] && currentCheckout='HEAD'

    _messagePlain_probe_var currentRepoDir
    _messagePlain_probe_var currentCheckout

    _messagePlain_nominal '@@@@@@@@@@ cd'
    ! _messagePlain_probe_cmd cd "$currentRepoDir" && _messagePlain_bad 'fail: upgrade_repository: cd' && _messageFAIL

    _messagePlain_nominal '@@@@@@@@@@ git checkout'
    ! _messagePlain_probe_cmd git checkout "$currentCheckout" && _messagePlain_bad 'fail: upgrade_repository: git checkout' && _messageFAIL

    _messagePlain_nominal '@@@@@@@@@@ git pull'
    ! _messagePlain_probe_cmd _gitBest pull && _messagePlain_bad 'fail: upgrade_repository: git pull' && _messageFAIL

    _messagePlain_nominal '@@@@@@@@@@ git submodule update --init --depth 1 --recursive'
    ! _messagePlain_probe_cmd _gitBest submodule update --init --depth 1 --recursive && _messagePlain_bad 'fail: upgrade_repository: submodule update --init --depth 1 --recursive' && _messageFAIL


    #--init
    #! _messagePlain_probe_cmd _gitBest submodule update --depth 1 && _messagePlain_bad 'fail: upgrade_repository: submodule update --depth 1' && _messageFAIL
    #! _messagePlain_probe_cmd _gitBest submodule update --depth 1 --recursive && _messagePlain_bad 'fail: upgrade_repository: submodule update --depth 1 --recursive' && _messageFAIL
    #! _messagePlain_probe_cmd _gitBest submodule update --depth 9000000 --recursive && _messagePlain_bad 'fail: upgrade_repository: submodule update --depth 9000000 --recursive' && _messageFAIL

    #! _messagePlain_probe_cmd _gitBest submodule update --recursive && _messagePlain_bad 'fail: upgrade_repository: submodule update --recursive' && _messageFAIL

    _messagePlain_nominal 'PASS'
    _messagePlain_good 'good: success: upgrade_repository'

    cd "$functionEntryPWD"
}

#_upgrade_binary_GitHubRelease_procedure /home/user/core/installations soaringDistributions/mirage335KernelBuild linux-lts-amd64-debian.tar.gz
_upgrade_binary_GitHubRelease_procedure() {
    _messageNormal 'init: _upgrade_binary'
    local functionEntryPWD
    functionEntryPWD="$PWD"

    local currentRepo
    currentRepo="$1"

    local currentFile
    currentFile="$2"

    local currentDestinationDir
    currentDestinationDir="$3"

    _messagePlain_probe_var currentRepo
    _messagePlain_probe_var currentFile
    _messagePlain_probe_var currentDestinationDir




    #export FORCE_WGET=true
    # TODO (if necessary): _wget_githubRelease-URL() { ... --no-progress-meter }
    #  May be an appropriate improvement to upstream "ubiquitous_bash" .
    _wget_githubRelease() {
        local currentURL=$(_wget_githubRelease-URL "$@")
        if [[ "$GH_TOKEN" == "" ]]
        then
            _messagePlain_probe curl --no-progress-meter -L -o "$3" "$currentURL" >&2
            curl --no-progress-meter -L -o "$3" "$currentURL"
        else
            if type -p gh > /dev/null 2>&1 && [[ "$GH_TOKEN" != "" ]] && [[ "$FORCE_WGET" != "true" ]]
            then
                _messagePlain_probe _gh_downloadURL "$currentURL" -O "$3" >&2
                _gh_downloadURL "$currentURL" -O "$3"
            else
                # Broken. Must use 'gh' instead.
                _messagePlain_probe curl --no-progress-meter -H "Authorization: Bearer "'$GH_TOKEN' -L -o "$3" "$currentURL" >&2
                curl --no-progress-meter -H "Authorization: Bearer $GH_TOKEN" -L -o "$3" "$currentURL"
            fi
        fi
        [[ ! -e "$3" ]] && _messagePlain_bad 'missing: '"$1"' '"$2"' '"$3" && return 1
        return 0
    }
    # Requires "$GH_TOKEN" .
    _gh_downloadURL() {
        local current_url
        local current_repo
        local current_tagName
        local current_file
        
        
        # ATTRIBUTION: ChatGPT GPT-4 2023-11-04 .
        
        # The provided URL
        current_url="$1"
        shift
        
        # Use `sed` to extract the parts of the URL
        current_repo=$(echo "$current_url" | sed -n 's|https://github.com/\([^/]*\)/\([^/]*\)/.*|\1/\2|p')
        current_tagName=$(echo "$current_url" | sed -n 's|https://github.com/[^/]*/[^/]*/releases/download/\([^/]*\)/.*|\1|p')
        current_file=$(echo "$current_url" | sed -n 's|https://github.com/[^/]*/[^/]*/releases/download/[^/]*/\(.*\)|\1|p')
        
        local current_fileOut
        current_fileOut="$current_file"
        if [[ "$1" == "-O" ]]
        then
            #_gh_downloadURL "${currentURL_array_reversed[$currentIterationNext1]}" -O "$currentAxelTmpFileRelative".tmp2
            current_fileOut="$2"
        fi
        
        # Use variables to construct the gh release download command
        local currentIteration
        currentIteration=0
        while ! [[ -e "$current_fileOut" ]] && [[ "$currentIteration" -lt 3 ]]
        do
            #gh release download "$current_tagName" -R "$current_repo" -p "$current_file" "$@"
            gh release download "$current_tagName" -R "$current_repo" -p "$current_file" "$@" 2> >(tail -n 10 >&2) | tail -n 10
            ! [[ -e "$current_fileOut" ]] && sleep 7
            let currentIteration=currentIteration+1
        done
        [[ -e "$current_fileOut" ]]
        return "$?"
    }




    cd "$safeTmp"

    _messagePlain_nominal '@@@@@@@@ _wget_githubRelease_internal-core'
    #! _messagePlain_probe_cmd _wget_githubRelease_internal-core "$currentRepo" "$currentFile" && _messagePlain_bad 'fail: _upgrade_binary: _wget_githubRelease_internal-core' && _messageFAIL
    ! _messagePlain_probe_cmd _wget_githubRelease_internal "$currentRepo" "$currentFile" && _messagePlain_bad 'fail: _upgrade_binary: _wget_githubRelease_internal' && _messageFAIL
    ! mv -f "$currentFile" "$currentDestinationDir"/"$currentFile" && _messagePlain_bad 'fail: _upgrade_binary: mv' && _messageFAIL

    _messagePlain_nominal 'PASS'
    _messagePlain_good 'good: success: _upgrade_binary'

    cd "$functionEntryPWD"
}
_upgrade_binary_GitHubRelease_sequence() {
    _start
    _upgrade_binary_GitHubRelease_procedure "$@"
    _stop
}
_upgrade_binary_GitHubRelease() {
    "$scriptAbsoluteLocation" _upgrade_binary_GitHubRelease_sequence "$@"
}


_upgrade_sequence() {
    echo
    echo '           init: _upgrade'
    echo
	local functionEntryPWD
	functionEntryPWD="$PWD"

    _start


    #_upgrade_repository /home/user/core/installations/mirage335KernelBuild

    #_upgrade_repository /home/user/core/installations/gpd-fan-driver-linux
    if ! [[ -e /home/user/core/installations/gpd-fan-driver-linux ]] || ! "$scriptAbsoluteLocation" _upgrade_repository /home/user/core/installations/gpd-fan-driver-linux
    then
        _messageNormal 'init: ubDistFetch_gitBestFetch_github: ''/home/user/core/installations gpd-fan-driver-linux'

        cd /home/user/core/installations
        _ubDistFetch_gitBestFetch_github_distllc /home/user/core/installations gpd-fan-driver-linux
        cd "$functionEntryPWD"
        
        _messagePlain_nominal 'PASS'
        _messagePlain_good 'good: success: ubDistFetch_gitBestFetch_github: ''/home/user/core/installations gpd-fan-driver-linux'
    fi


    mkdir -p /home/user/core/installations/kernel_linux
    _upgrade_binary_GitHubRelease_procedure soaringDistributions/mirage335KernelBuild linux-lts-amd64-debian.tar.gz /home/user/core/installations/kernel_linux
    _upgrade_binary_GitHubRelease_procedure soaringDistributions/mirage335KernelBuild linux-mainline-amd64-debian.tar.gz /home/user/core/installations/kernel_linux
    #_upgrade_binary_GitHubRelease_procedure soaringDistributions/mirage335KernelBuild linux-lts-server-amd64-debian.tar.gz /home/user/core/installations/kernel_linux
    _upgrade_binary_GitHubRelease_procedure soaringDistributions/mirage335KernelBuild linux-mainline-server-amd64-debian.tar.gz /home/user/core/installations/kernel_linux


    mkdir -p /home/user/core/installations/ubcp
    _upgrade_binary_GitHubRelease_procedure mirage335-colossus/ubiquitous_bash ubcp-cygwin-portable-installer.log /home/user/core/installations/ubcp
    _upgrade_binary_GitHubRelease_procedure mirage335-colossus/ubiquitous_bash _mitigate-ubcp.log /home/user/core/installations/ubcp
    _upgrade_binary_GitHubRelease_procedure mirage335-colossus/ubiquitous_bash _setupUbiquitous.log /home/user/core/installations/ubcp
    _upgrade_binary_GitHubRelease_procedure mirage335-colossus/ubiquitous_bash _test-lean.log /home/user/core/installations/ubcp

    _upgrade_binary_GitHubRelease_procedure mirage335-colossus/ubiquitous_bash package_ubcp-core.7z /home/user/core/installations/ubcp


    _upgrade_repository /home/user/core/installations/audioManager
    _upgrade_repository /home/user/core/installations/ChannelScanKit

    _upgrade_repository /home/user/core/installations/mouserTools


    _upgrade_repository /home/user/core/infrastructure/ubDistBuild
    _upgrade_repository /home/user/core/infrastructure/ubDistFetch

    _upgrade_repository /home/user/core/infrastructure/virtuousCritter

    _upgrade_repository /home/user/core/infrastructure/flightDeck
    _upgrade_repository /home/user/core/infrastructure/kinematicBase-large
    _upgrade_repository /home/user/core/infrastructure/tinyMakeLab
    

    _upgrade_repository /home/user/core/infrastructure/ubiquitous_bash
    #/home/user/core/infrastructure/ubiquitous_bash_bundle.git

    _upgrade_repository /home/user/core/infrastructure/extendedInterface

    _upgrade_repository /home/user/core/infrastructure/mirage335_documents
    _upgrade_repository /home/user/core/infrastructure/mirage335GizmoScience
    

    _upgrade_repository /home/user/core/infrastructure/CoreAutoSSH


	_upgrade_repository /home/user/core/infrastructure/coreoracle


    _upgrade_repository /home/user/core/infrastructure/flipKey
	cd /home/user/core/infrastructure/flipKey
	./ubiquitous_bash.sh _package
	#cd /home/user/core/infrastructure
    cd "$functionEntryPWD"

	
	_upgrade_repository /home/user/core/infrastructure/credManager
    


    _upgrade_repository /home/user/core/infrastructure/arduinoUbiquitous


    _messageNormal 'special: arduinoUbiquitous: special: submodules'

    cd /home/user/core/infrastructure/arduinoUbiquitous
    ! _messagePlain_probe_cmd _gitBest submodule update --init --depth 1 ./_lib/openocd-static && _messagePlain_bad 'fail: submodule update --init --depth 1 ./_lib/openocd-static' && _messageFAIL

    cd /home/user/core/infrastructure/arduinoUbiquitous/_lib/openocd-static
    ! _messagePlain_probe_cmd _gitBest submodule update --init --depth 9000000 --recursive ./_lib/openocd-build-script-static && _messagePlain_bad 'fail: submodule update --init --depth 9000000 --recursive ./_lib/openocd-build-script-static' && _messageFAIL
    ! _messagePlain_probe_cmd _gitBest submodule update --init --depth 9000000 --recursive ./_lib/openocd-code && _messagePlain_bad 'fail: submodule update --init --depth 9000000 --recursive ./_lib/openocd-code' && _messageFAIL

    cd /home/user/core/infrastructure/arduinoUbiquitous
    ! _messagePlain_probe_cmd _gitBest submodule update --init --depth 1 --recursive && _messagePlain_bad 'fail: submodule update --init --depth 1 --recursive' && _messageFAIL

    _messagePlain_nominal 'PASS'
    _messagePlain_good 'good: success: arduinoUbiquitous: special: submodules'



    _upgrade_repository /home/user/core/infrastructure/BOM_designer

    _upgrade_repository /home/user/core/infrastructure/Freerouting

    _upgrade_repository /home/user/core/infrastructure/gEDA_designer

    #_upgrade_repository /home/user/core/infrastructure/metaBus

    _upgrade_repository /home/user/core/infrastructure/PanelBoard

    _upgrade_repository /home/user/core/infrastructure/PatchRap

    _upgrade_repository /home/user/core/infrastructure/PatchRap_LulzBot

    _upgrade_repository /home/user/core/infrastructure/PatchRap_to_CNC

    _upgrade_repository /home/user/core/infrastructure/pcb-ioAutorouter

    #_upgrade_repository /home/user/core/infrastructure/RigidTable

    _upgrade_repository /home/user/core/infrastructure/scriptedIllustrator

    #_upgrade_repository /home/user/core/infrastructure/SigBlockly-mod

    _upgrade_repository /home/user/core/infrastructure/stepperTester

    #_upgrade_repository /home/user/core/infrastructure/TazIntermediate

    _upgrade_repository /home/user/core/infrastructure/translate2geda

    _upgrade_repository /home/user/core/infrastructure/gEDA_refdes_renumALL

    _upgrade_repository /home/user/core/infrastructure/webClient

    #_upgrade_repository /home/user/core/infrastructure/zipTiePanel

    _upgrade_repository /home/user/core/infrastructure/VR_Headset_Hanger

    #/home/user/core/infrastructure/aftermarket_8kX_hinge

    #_upgrade_repository /home/user/core/infrastructure/LinearPSU

    #_upgrade_repository /home/user/core/infrastructure/30MHzLowPass

    _upgrade_repository /home/user/core/infrastructure/HVDC_Engine


    _upgrade_repository /home/user/core/infrastructure/quickWriter


    _upgrade_repository /home/user/core/infrastructure/pumpCompanion
    _upgrade_repository /home/user/core/infrastructure/puddleJumper

    _upgrade_repository /home/user/core/infrastructure/iconArt

    _upgrade_repository /home/user/core/variant/ubdist_dummy

    _upgrade_repository /home/user/core/variant/ubdist_puddleJumper

    _upgrade_repository /home/user/core/info/issues





    cd "$functionEntryPWD"
    echo
    echo '          PASS'
    echo '         good: success: _upgrade'
    echo
    _stop
}
_upgrade() {
    "$scriptAbsoluteLocation" _upgrade_sequence "$@"
}





# DUBIOUS. WARNING: Strongly discouraged. May be untested. Would rely on continuing to run code from in-place replaced bash shell script.
_upgrade_self_sequence() {
    _messageNormal 'init: _upgrade_self_sequence'
}
_upgrade_all() {
    "$scriptAbsoluteLocation" _upgrade_self_sequence "$@"
    "$scriptAbsoluteLocation" _upgrade_sequence "$@"
}
