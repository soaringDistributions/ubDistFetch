##### Core

_core_FAIL() {
	_safeEcho_newline "$@" > "$scriptLib"/FAIL
	_messagePlain_bad 'fail: '"$@"
	_messageFAIL
}

_wget_githubRelease_internal-core() {
	_wget_githubRelease_internal "$@"
	[[ ! -e "$2" ]] && _core_FAIL 'missing: '"$1"' '"$2"
}

# "$1" ~= "$scriptLib"/core/infrastructure
# "$2" ~= git@github.com:mirage335-colossus/ubiquitous_bash.git
# "$3" ~= ubiquitous_bash
# "$4" ~= HEAD (optional)
_ubDistFetch_gitBestFetch() {
	[[ -e "$1"/"$3" ]] && return 0
	
	local functionEntryPWD
	functionEntryPWD="$PWD"
	
	local currentCheckout
	currentCheckout="$4"
	[[ "$currentCheckout" == "" ]] && currentCheckout=HEAD

	git config --global checkout.workers -1
	
	! _messagePlain_probe_cmd mkdir -p "$1"  && _core_FAIL
	! _messagePlain_probe_cmd cd "$1" && _core_FAIL
	#_gitBest clone --depth 1 --recursive "$2"
	if [[ "$4" == "" ]] || [[ "$4" == "HEAD" ]] || [[ "$4" == "main" ]] || [[ "$4" == "master" ]]
	then
		_gitBest clone --depth 1 "$2"
	elif [[ $(_safeEcho_newline "$4" | wc -c | tr -dc '0-9') -ge 40 ]]
	then
		_gitBest clone "$2"
	fi
	#[[ ! -e "$1"/"$3" ]] && _core_FAIL
	! _messagePlain_probe_cmd cd "$1"/"$3" && _core_FAIL
	! _messagePlain_probe_cmd git checkout "$currentCheckout" && _core_FAIL
	if [[ "$4" == "" ]] || [[ "$4" == "HEAD" ]] || [[ "$4" == "main" ]] || [[ "$4" == "master" ]]
	then
		! _messagePlain_probe_cmd _gitBest pull && _core_FAIL
	elif [[ $(_safeEcho_newline "$4" | wc -c | tr -dc '0-9') -ge 40 ]]
	then
		_messagePlain_probe_cmd _gitBest pull
	fi
	! _messagePlain_probe_cmd _gitBest submodule update --init --depth 1 --recursive && _core_FAIL
	
	cd "$functionEntryPWD"
}

_ubDistFetch_gitBestFetch_github_mirage335-gizmos() {
	_messageNormal '########## '$(_safeEcho_newline "$1" | tail -c 25 | rev | cut -d/ -f1 | tr -dc 'A-Za-z0-9' | rev)' '"$2"
	if ! _ubDistFetch_gitBestFetch "$1" git@github.com:mirage335-gizmos/"$2".git "$2"
	then
		_core_FAIL '_ubDistFetch_gitBestFetch_github_mirage335-gizmos '"$@"
		_messageFAIL
	fi
	return 0
}

_ubDistFetch_gitBestFetch_github_mirage335-colossus() {
	_messageNormal '########## '$(_safeEcho_newline "$1" | tail -c 25 | rev | cut -d/ -f1 | tr -dc 'A-Za-z0-9' | rev)' '"$2"
	if ! _ubDistFetch_gitBestFetch "$1" git@github.com:mirage335-colossus/"$2".git "$2"
	then
		_core_FAIL '_ubDistFetch_gitBestFetch_github_mirage335-colossus '"$@"
		_messageFAIL
	fi
	return 0
}

_ubDistFetch_gitBestFetch_github_mirage335() {
	_messageNormal '########## '$(_safeEcho_newline "$1" | tail -c 25 | rev | cut -d/ -f1 | tr -dc 'A-Za-z0-9' | rev)' '"$2"
	if ! _ubDistFetch_gitBestFetch "$1" git@github.com:mirage335/"$2".git "$2"
	then
		_core_FAIL '_ubDistFetch_gitBestFetch_github_mirage335 '"$@"
		_messageFAIL
	fi
	return 0
}

_ubDistFetch_gitBestFetch_github_distllc() {
	_messageNormal '########## '$(_safeEcho_newline "$1" | tail -c 25 | rev | cut -d/ -f1 | tr -dc 'A-Za-z0-9' | rev)' '"$2"
	if ! _ubDistFetch_gitBestFetch "$1" git@github.com:soaringDistributions/"$2".git "$2"
	then
		_core_FAIL '_ubDistFetch_gitBestFetch_github_distllc '"$@"
		_messageFAIL
	fi
	return 0
}


_ubDistFetch() {
	local functionEntryPWD
	functionEntryPWD="$PWD"
	_start
	
	# If directory exists, pull updates instead of deleting and recreating.
	export safeToDeleteGit="true"
	_safeRMR "$scriptLib"/core/infrastructure
	_safeRMR "$scriptLib"/core/installations
	
	mkdir -p "$scriptLib"/core/infrastructure
	mkdir -p "$scriptLib"/core/installations
	
	rm -f "$scriptLib"/FAIL > /dev/null 2>&1
	
	
	cd "$scriptLib"/core/installations
	
	_messageNormal '########## installations: 'copyleft
	[[ ! -e "$scriptLib"/core/installations/gpl-3.0.txt ]] && cd "$scriptLib"/core/installations && wget https://www.gnu.org/licenses/gpl-3.0.txt
	[[ ! -e "$scriptLib"/core/installations/agpl-3.0.txt ]] && cd "$scriptLib"/core/installations && wget https://www.gnu.org/licenses/agpl-3.0.txt
	
	
	_messageNormal '########## installations: 'programs
	if ! [[ -e "$scriptLib"/core/installations/pstoedit-3.75 ]]
	then
		cd "$scriptLib"/core/installations
		#wget 'https://phoenixnap.dl.sourceforge.net/project/pstoedit/pstoedit/3.75/pstoedit-3.75.tar.gz' -O pstoedit-3.75.tar.gz
		wget 'https://sourceforge.net/projects/pstoedit/files/pstoedit/3.75/pstoedit-3.75.tar.gz/download' -O pstoedit-3.75.tar.gz
		! _messagePlain_probe_cmd tar xf pstoedit-3.75.tar.gz && _core_FAIL
		rm -f pstoedit-3.75.tar.gz
	fi
	! [[ -e "$scriptLib"/core/installations/pstoedit-3.75 ]] && _core_FAIL 'missing: pstoedit-3.75'


	if ! [[ -e "$scriptLib"/core/installations/xclipsync ]]
	then
		cd "$scriptLib"/core/installations
		! _messagePlain_probe_cmd _gitBest clone --recursive git@github.com:apenwarr/xclipsync.git && _core_FAIL
	fi
	! [[ -e "$scriptLib"/core/installations/xclipsync ]] && _core_FAIL 'missing: xclipsync'


	if ! [[ -e "$scriptLib"/core/installations/slvs_py ]]
	then
		cd "$scriptLib"/core/installations
		! _messagePlain_probe_cmd _gitBest clone --recursive git@github.com:realthunder/slvs_py.git && _core_FAIL
	fi
	! [[ -e "$scriptLib"/core/installations/slvs_py ]] && _core_FAIL 'missing: slvs_py'
	
	if ! [[ -e "$scriptLib"/core/installations/solvespace ]]
	then
		cd "$scriptLib"/core/installations
		! _messagePlain_probe_cmd _gitBest clone --recursive git@github.com:realthunder/solvespace.git && _core_FAIL
	fi
	! [[ -e "$scriptLib"/core/installations/solvespace ]] && _core_FAIL 'missing: solvespace'
	
	if ! [[ -e "$scriptLib"/core/installations/FreeCAD ]]
	then
		cd "$scriptLib"/core/installations
		#! _messagePlain_probe_cmd _gitBest clone --depth 1 --recursive git@github.com:realthunder/FreeCAD.git && _core_FAIL
		#! _messagePlain_probe_cmd _gitBest clone --depth 1 git@github.com:realthunder/FreeCAD.git && _core_FAIL
		! _messagePlain_probe_cmd _gitBest clone --depth 1 --bare git@github.com:realthunder/FreeCAD.git && _core_FAIL
	fi
	! [[ -e "$scriptLib"/core/installations/FreeCAD ]] && ! [[ -e "$scriptLib"/core/installations/FreeCAD.git ]] && _core_FAIL 'missing: FreeCAD'
	


	if ! [[ -e "$scriptLib"/core/installations/gr-pipe ]]
	then
		cd "$scriptLib"/core/installations
		! _messagePlain_probe_cmd _gitBest clone --recursive git@github.com:bkerler/gr-pipe.git && _core_FAIL
	fi
	! [[ -e "$scriptLib"/core/installations/gr-pipe ]] && _core_FAIL 'missing: gr-pipe'
	
	
	#_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations mirage335KernelBuild
	_ubDistFetch_gitBestFetch_github_distllc "$scriptLib"/core/installations mirage335KernelBuild
	
	
	
	_messageNormal '########## installations: 'linux-lts
	mkdir -p "$scriptLib"/core/installations/kernel_linux
	if [[ ! -e "$scriptLib"/core/installations/kernel_linux/linux-lts-amd64-debian.tar.gz ]]
	then
		cd "$scriptLib"/core/installations/
		
		_wget_githubRelease_internal-core soaringDistributions/mirage335KernelBuild linux-lts-amd64-debian.tar.gz
		
		mv -f linux-lts-amd64-debian.tar.gz kernel_linux/linux-lts-amd64-debian.tar.gz
		cd "$scriptLib"/core/installations/kernel_linux
		tar xf linux-lts-amd64-debian.tar.gz
	fi
	
	_messageNormal '########## installations: 'linux-mainline
	mkdir -p "$scriptLib"/core/installations/kernel_linux
	if [[ ! -e "$scriptLib"/core/installations/kernel_linux/linux-mainline-amd64-debian.tar.gz ]]
	then
		cd "$scriptLib"/core/installations/

		_wget_githubRelease_internal-core soaringDistributions/mirage335KernelBuild linux-mainline-amd64-debian.tar.gz

		mv -f linux-mainline-amd64-debian.tar.gz kernel_linux/linux-mainline-amd64-debian.tar.gz
		cd "$scriptLib"/core/installations/kernel_linux
		tar xf linux-mainline-amd64-debian.tar.gz
	fi
	
	
	_messageNormal '########## installations: 'ubcp
	mkdir -p "$scriptLib"/core/installations/ubcp

	# Not strictly necessary for development. Prefer installer for 'extendedInterface' instead of direct installation from 'package_ubiquitous_bash-msw.7z' .
	if [[ ! -e "$scriptLib"/core/installations/ubcp/package_ubiquitous_bash-msw.7z ]] && [[ ! -e "$scriptLib"/core/installations/ubcp/_mitigate-ubcp.log ]] && [[ ! -e "$scriptLib"/core/installations/ubcp/_setupUbiquitous.log ]] && [[ ! -e "$scriptLib"/core/installations/ubcp/_test-lean.log ]]
	then
		cd "$scriptLib"/core/installations/ubcp
		##_wget_githubRelease_internal-core mirage335-colossus/ubiquitous_bash package_ubiquitous_bash-msw.7z
		#_wget_githubRelease_internal-core mirage335-colossus/ubiquitous_bash package_ubiquitous_bash-msw.log
		
		_wget_githubRelease_internal-core mirage335-colossus/ubiquitous_bash ubcp-cygwin-portable-installer.log
		_wget_githubRelease_internal-core mirage335-colossus/ubiquitous_bash _mitigate-ubcp.log
		_wget_githubRelease_internal-core mirage335-colossus/ubiquitous_bash _setupUbiquitous.log
		_wget_githubRelease_internal-core mirage335-colossus/ubiquitous_bash _test-lean.log
	fi

	# Not strictly necessary for development. Contents of 'package_ubcp-core.7z' can be added to an 'ubiquitous_bash' based project, this 'rotten' package merely includes a template 'ubiquitous_bash' project.
	if [[ ! -e "$scriptLib"/core/installations/ubcp/package_ubiquitous_bash-msw-rotten.7z ]] && [[ ! -e "$scriptLib"/core/installations/ubcp/package_ubiquitous_bash-msw-rotten.log ]]
	then
		cd "$scriptLib"/core/installations/ubcp
		##_wget_githubRelease_internal-core mirage335-colossus/ubiquitous_bash package_ubiquitous_bash-msw-rotten.7z
		#_wget_githubRelease_internal-core mirage335-colossus/ubiquitous_bash package_ubiquitous_bash-msw-rotten.log
	fi

	# WARNING: Essential.
	if [[ ! -e "$scriptLib"/core/installations/ubcp/package_ubcp-core.7z ]] && [[ ! -e "$scriptLib"/core/installations/ubcp/package_ubcp-core.log ]]
	then
		cd "$scriptLib"/core/installations/ubcp
		_wget_githubRelease_internal-core mirage335-colossus/ubiquitous_bash package_ubcp-core.7z
		_wget_githubRelease_internal-core mirage335-colossus/ubiquitous_bash package_ubcp-core.log
	fi
	
	
	# May be obsolete. Live ISO itself should now include everything necessary to automatically derive the 'miniCD' ISO .
	_messageNormal '########## installations: 'mirage335TechArchive_discImages
	mkdir -p "$scriptLib"/core/installations/mirage335TechArchive_discImages
	if [[ ! -e "$scriptLib"/core/installations/mirage335TechArchive_discImages/m335TechArc_mCD.iso ]]
	then
		cd "$scriptLib"/core/installations/
		# ATTENTION: TODO: Temporarily unavailable.
		#_wget mirage335TechArchive_discImages/m335TechArc_mCD.iso -O m335TechArc_mCD.iso
		#mv -f m335TechArc_mCD.iso mirage335TechArchive_discImages/m335TechArc_mCD.iso
	fi
	
	
	
	
	#_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations mirage335GizmoScience
	
	

	if ! [[ -e "$scriptLib"/core/installations/klipper ]]
	then
		cd "$scriptLib"/core/installations
		! _messagePlain_probe_cmd _gitBest clone --depth 1 --recursive https://github.com/Klipper3d/klipper && _core_FAIL
	fi
	! [[ -e "$scriptLib"/core/installations/klipper ]] && _core_FAIL 'missing: klipper'



	#if ! [[ -e "$scriptLib"/core/installations/kiauh ]]
	#then
		#cd "$scriptLib"/core/installations
		#! _messagePlain_probe_cmd _gitBest clone --depth 1 --recursive https://github.com/dw-0/kiauh.git && _core_FAIL
	#fi
	#! [[ -e "$scriptLib"/core/installations/kiauh ]] && _core_FAIL 'missing: kiauh'



	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations kiauh-automatic



	
	
	cd "$scriptLib"/core/infrastructure
	
	_ubDistFetch_gitBestFetch_github_distllc "$scriptLib"/core/infrastructure ubDistBuild

	_ubDistFetch_gitBestFetch_github_distllc "$scriptLib"/core/infrastructure ubDistFetch


	cd "$scriptLib"/core/infrastructure
	
	_ubDistFetch_gitBestFetch_github_mirage335-gizmos "$scriptLib"/core/infrastructure flightDeck

	_ubDistFetch_gitBestFetch_github_mirage335-gizmos "$scriptLib"/core/infrastructure kinematicBase-large


	
	
	_messageNormal '########## infrastructure: 'moby
	if ! [[ -e "$scriptLib"/core/infrastructure/moby ]]
	then
		cd "$scriptLib"/core/infrastructure
		wget 'https://codeload.github.com/moby/moby/zip/3e1df952b7d693ac3961f492310852bdf3106240' -O moby-3e1df952b7d693ac3961f492310852bdf3106240.zip
		unzip moby-3e1df952b7d693ac3961f492310852bdf3106240.zip
		rm -f moby-3e1df952b7d693ac3961f492310852bdf3106240.zip
		mv -f moby-3e1df952b7d693ac3961f492310852bdf3106240 moby
	fi
	_ubDistFetch_gitBestFetch "$scriptLib"/core/infrastructure git@github.com:moby/moby.git moby 3e1df952b7d693ac3961f492310852bdf3106240
	
	#_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure ubiquitous_bash
	_ubDistFetch_gitBestFetch_github_mirage335-colossus "$scriptLib"/core/infrastructure ubiquitous_bash
	
	#_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure extendedInterface
	_ubDistFetch_gitBestFetch_github_mirage335-colossus "$scriptLib"/core/infrastructure extendedInterface
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure mirage335_documents
	


	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure mirage335GizmoScience
	
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure CoreAutoSSH
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure coreoracle
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure flipKey
	cd "$scriptLib"/core/infrastructure/flipKey
	./ubiquitous_bash.sh _package
	cd "$scriptLib"/core/infrastructure
	
	
	
	#_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure arduinoUbiquitous
	if [[ ! -e "$scriptLib"/core/infrastructure/arduinoUbiquitous ]]
	then
		cd "$scriptLib"/core/infrastructure
		_gitBest clone --depth 1 git@github.com:mirage335/arduinoUbiquitous.git
		[[ ! -e "$scriptLib"/core/infrastructure/arduinoUbiquitous ]] && _core_FAIL 'missing: arduinoUbiquitous'
		
		cd "$scriptLib"/core/infrastructure/arduinoUbiquitous
		
		cd "$scriptLib"/core/infrastructure/arduinoUbiquitous/
		! _messagePlain_probe_cmd _gitBest submodule update --init --depth 1 ./_lib/openocd-static && _core_FAIL
		cd "$scriptLib"/core/infrastructure/arduinoUbiquitous/_lib/openocd-static
		! _messagePlain_probe_cmd _gitBest submodule update --init --depth 9000000 --recursive ./_lib/openocd-build-script-static && _core_FAIL
		! _messagePlain_probe_cmd _gitBest submodule update --init --depth 9000000 --recursive ./_lib/openocd-code && _core_FAIL
		
		cd "$scriptLib"/core/infrastructure/arduinoUbiquitous/
		! _messagePlain_probe_cmd _gitBest submodule update --init --depth 1 --recursive && _core_FAIL
	fi
	
	
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure BOM_designer
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure freecad-assembly2
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure Freerouting
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure gEDA_designer
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure metaBus
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure PanelBoard
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure PatchRap
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure PatchRap_LulzBot
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure PatchRap_to_CNC
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure pcb-ioAutorouter
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure RigidTable
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure scriptedIllustrator
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure SigBlockly-mod
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure stepperTester
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure TazIntermediate
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure translate2geda
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure webClient
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure zipTiePanel
	
	
	
	cd "$scriptLib"
	cd "$functionEntryPWD"
	_stop
}



_ubDistFetch_package() {
	[[ -e "$scriptLib"/FAIL ]] && _messagePlain_bad 'flag: "$scriptLib"/FAIL' && _messageFAIL
	cd "$scriptLib"
	rm -f "$scriptLib"/core.tar.xz > /dev/null 2>&1
	[[ "$current_XZ_OPT_core" == "" ]] && export current_XZ_OPT_core="-5"
	env XZ_OPT="$current_XZ_OPT_core" tar -cJvf "$scriptLib"/core.tar.xz ./core
}


_ubDistFetch_split() {
	local functionEntryPWD
	functionEntryPWD="$PWD"


	cd "$scriptLib"
	split -b 1856000000 -d core.tar.xz core.tar.xz.part


	cd "$functionEntryPWD"
}


_refresh_anchors() {
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_ubDistFetch.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_ubDistFetch_package.bat
}
