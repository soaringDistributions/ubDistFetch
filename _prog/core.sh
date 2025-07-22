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

_ubDistFetch_gitBestFetch_github_mirage335-special() {
	_messageNormal '########## '$(_safeEcho_newline "$1" | tail -c 25 | rev | cut -d/ -f1 | tr -dc 'A-Za-z0-9' | rev)' '"$2"
	if ! _ubDistFetch_gitBestFetch "$1" git@github.com:mirage335-special/"$2".git "$2"
	then
		_core_FAIL '_ubDistFetch_gitBestFetch_github_mirage335-special '"$@"
		_messageFAIL
	fi
	return 0
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
	_safeRMR "$scriptLib"/core/variant
	_safeRMR "$scriptLib"/core/info
	_safeRMR "$scriptLib"/core/cognition
	
	mkdir -p "$scriptLib"/core/infrastructure
	mkdir -p "$scriptLib"/core/installations
	mkdir -p "$scriptLib"/core/variant
	mkdir -p "$scriptLib"/core/info
	mkdir -p "$scriptLib"/core/cognition
	
	rm -f "$scriptLib"/FAIL > /dev/null 2>&1
	
	
	cd "$scriptLib"/core/installations
	
	_messageNormal '########## installations: 'copyleft
	[[ ! -e "$scriptLib"/core/installations/gpl-3.0.txt ]] && cd "$scriptLib"/core/installations && wget https://www.gnu.org/licenses/gpl-3.0.txt
	[[ ! -e "$scriptLib"/core/installations/gpl-3.0.txt ]] && cd "$scriptLib"/core/installations && cp "$scriptAbsoluteFolder"/_ref/gpl-3.0.txt ./
	[[ ! -e "$scriptLib"/core/installations/gpl-3.0.txt ]] && _core_FAIL 'missing: gpl-3.0.txt'
	[[ ! -e "$scriptLib"/core/installations/agpl-3.0.txt ]] && cd "$scriptLib"/core/installations && wget https://www.gnu.org/licenses/agpl-3.0.txt
	[[ ! -e "$scriptLib"/core/installations/agpl-3.0.txt ]] && cd "$scriptLib"/core/installations && cp "$scriptAbsoluteFolder"/_ref/agpl-3.0.txt ./
	[[ ! -e "$scriptLib"/core/installations/agpl-3.0.txt ]] && _core_FAIL 'missing: agpl-3.0.txt'


	
	_messageNormal '########## installations: 'Debian Packages
	cd "$scriptLib"/core/installations
	if ! [[ -e "$scriptLib"/"core/installations/curlftpfs/curlftpfs_0.9.2-9+b1_amd64.deb" ]]
	then
		mkdir -p "$scriptLib"/core/installations/curlftpfs
		curl -L 'https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/curlftpfs/curlftpfs_0.9.2-9+b1_amd64.deb' -o "$scriptLib"/"core/installations/curlftpfs/curlftpfs_0.9.2-9+b1_amd64.deb"
		##yes | sudo -n dpkg -i "$scriptLib"/"core/installations/curlftpfs/curlftpfs_0.9.2-9+b1_amd64.deb"
	fi
	cd "$scriptLib"/core/installations


	
	_messageNormal '########## installations: 'source_code
	# MSW Binary for VirtualBox apparently depends on 'vc_redist', which may not be or may not remain a usable dependency. Thus, although Linux VirtualBox may be usefully available, only the source code may exist for MSW.
	# Any use or availability of VirtualBox, not just MSW, is now strongly discouraged, and likely will be eliminated eventually in favor of QEMU .
	# https://forums.virtualbox.org/viewtopic.php?t=108104
	#  Seems there is some controversy here. In fact, there is license text to allow redistribution of 'vc_redist.x64.exe' . Microsoft's own knowledgeable 'Bing Chat' confirms Microsoft does allow sharing the file so long as some guidelines are followed.
	# https://learn.microsoft.com/en-us/cpp/windows/redistributing-visual-cpp-files?view=msvc-170
	# https://visualstudio.microsoft.com/license-terms/
	# https://visualstudio.microsoft.com/license-terms/vs2022-ga-community/
	#  'Distributable Code'
	# https://learn.microsoft.com/en-us/cpp/windows/redistributing-visual-cpp-files?view=msvc-170
	#  The obvious conclusion is that MSW documentation regarding redistributable licensing either is not well documented or more likely relies on legalease which Oracle dislikes. In any case, transitioning away from and preserving open-source code from, VirtualBox, is a reasonable response at this time.
	# https://forums.virtualbox.org/viewtopic.php?t=108556&start=30
	#  There is apparently some possibility that VirtualBox 7.0.13 has again included 'vc_redist', and that the removal was for some technical reason. However, the eventual elimination of VirtualBox should still occur, as with any case of erratic dependency issues.
	if ! [[ -e "$scriptLib"/core/installations/VirtualBox-7.0.12a.tar.bz2 ]]
	then
		cd "$scriptLib"/core/installations
		wget 'https://download.virtualbox.org/virtualbox/7.0.12/VirtualBox-7.0.12a.tar.bz2'
	fi
	! [[ -e "$scriptLib"/core/installations/VirtualBox-7.0.12a.tar.bz2 ]] && _core_FAIL 'missing: VirtualBox-7.0.12a.tar.bz2'
	
	
	_messageNormal '########## installations: 'programs
	if ! [[ -e "$scriptLib"/core/installations/pstoedit-3.75 ]]
	then
		cd "$scriptLib"/core/installations
		#wget 'https://phoenixnap.dl.sourceforge.net/project/pstoedit/pstoedit/3.75/pstoedit-3.75.tar.gz' -O pstoedit-3.75.tar.gz
		#wget 'https://sourceforge.net/projects/pstoedit/files/pstoedit/3.75/pstoedit-3.75.tar.gz/download' -O pstoedit-3.75.tar.gz
		wget 'https://web.archive.org/web/20210913182309if_/https://versaweb.dl.sourceforge.net/project/pstoedit/pstoedit/3.75/pstoedit-3.75.tar.gz' -O pstoedit-3.75.tar.gz
		! _messagePlain_probe_cmd tar xf pstoedit-3.75.tar.gz && _core_FAIL
		#rm -f pstoedit-3.75.tar.gz
	fi
	! [[ -e "$scriptLib"/core/installations/pstoedit-3.75 ]] && _core_FAIL 'missing: pstoedit-3.75'
	
	
	# https://www.kb.cert.org/vuls/id/332928/
	#  'This issue is addressed in Ghostscript version 9.24.
	#  'remove Ghostscript from your system'
	#   CAUTION: There seems to be some political effort to end the existence of Ghostscript. Ghostscript is a necessity for generating accurate CAD integratable andprintable PDF output from EDA. Until Ghostscript is not going away, a known working version of the source code MUST be shipped to ensure availability for possible maintenance separate from upstream dist/OS if necessary.
	if ! [[ -e "$scriptLib"/core/installations/ghostscript-10.02.1 ]]
	then
		cd "$scriptLib"/core/installations
		wget 'https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10021/ghostscript-10.02.1.tar.gz' -O ghostscript-10.02.1.tar.gz
		#! _messagePlain_probe_cmd tar xf ghostscript-10.02.1.tar.gz && _core_FAIL
		#rm -f ghostscript-10.02.1.tar.gz
	fi
	#! [[ -e "$scriptLib"/core/installations/ghostscript-10.02.1 ]] && _core_FAIL 'missing: ghostscript-10.02.1'
	! [[ -e "$scriptLib"/core/installations/ghostscript-10.02.1.tar.gz ]] && _core_FAIL 'missing: ghostscript-10.02.1.tar.gz'


	if ! [[ -e "$scriptLib"/core/installations/xclipsync ]]
	then
		cd "$scriptLib"/core/installations
		! _messagePlain_probe_cmd _gitBest clone --recursive git@github.com:apenwarr/xclipsync.git && _core_FAIL
	fi
	! [[ -e "$scriptLib"/core/installations/xclipsync ]] && _core_FAIL 'missing: xclipsync'


	if ! [[ -e "$scriptLib"/core/installations/pycam ]]
 	then
  		cd "$scriptLib"/core/installations
 		#git clone --depth 1 --recursive git://pycam.git.sourceforge.net/gitroot/pycam/pycam
 		_gitBest clone --depth 1 --recursive git@github.com:SebKuzminsky/pycam.git
 		cd "$scriptLib"/core/installations/pycam
 		_gitBest fetch --shallow-exclude=v0.6.3
   	fi
	! [[ -e "$scriptLib"/core/installations/pycam ]] && _core_FAIL 'missing: pycam'


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





	_ubDistFetch_gitBestFetch_github_distllc "$scriptLib"/core/installations CAD_Assistant





	if ! [[ -e "$scriptLib"/core/installations/gr-pipe ]]
	then
		cd "$scriptLib"/core/installations
		! _messagePlain_probe_cmd _gitBest clone --recursive git@github.com:bkerler/gr-pipe.git && _core_FAIL
	fi
	! [[ -e "$scriptLib"/core/installations/gr-pipe ]] && _core_FAIL 'missing: gr-pipe'
	
	
	#_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations mirage335KernelBuild
	_ubDistFetch_gitBestFetch_github_distllc "$scriptLib"/core/installations mirage335KernelBuild


	_ubDistFetch_gitBestFetch_github_distllc "$scriptLib"/core/installations gpd-fan-driver-linux

	# Should be an unnecessary conveninence, provided by 'ubDistBuild/_lib/_get_hardware.sh' called during 'ubDistBuild' ...
	_ubDistFetch_gitBestFetch_github_distllc "$scriptLib"/core/installations getHardware-CoralTPU


	_ubDistFetch_gitBestFetch_github_distllc "$scriptLib"/core/installations libcudadev_stub


	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations freecad-converter
	
	
	
	_messageNormal '########## installations: 'linux-lts
	mkdir -p "$scriptLib"/core/installations/kernel_linux
	if [[ ! -e "$scriptLib"/core/installations/kernel_linux/linux-lts-amd64-debian.tar.gz ]]
	then
		cd "$scriptLib"/core/installations/
		
		_wget_githubRelease_internal-core soaringDistributions/mirage335KernelBuild linux-lts-amd64-debian.tar.gz
		
		mv -f linux-lts-amd64-debian.tar.gz kernel_linux/linux-lts-amd64-debian.tar.gz
		cd "$scriptLib"/core/installations/kernel_linux
		#tar xf linux-lts-amd64-debian.tar.gz
	fi
	
	_messageNormal '########## installations: 'linux-mainline
	mkdir -p "$scriptLib"/core/installations/kernel_linux
	if [[ ! -e "$scriptLib"/core/installations/kernel_linux/linux-mainline-amd64-debian.tar.gz ]]
	then
		cd "$scriptLib"/core/installations/

		_wget_githubRelease_internal-core soaringDistributions/mirage335KernelBuild linux-mainline-amd64-debian.tar.gz

		mv -f linux-mainline-amd64-debian.tar.gz kernel_linux/linux-mainline-amd64-debian.tar.gz
		cd "$scriptLib"/core/installations/kernel_linux
		#tar xf linux-mainline-amd64-debian.tar.gz
	fi
	
	#_messageNormal '########## installations: 'linux-lts-server
	#mkdir -p "$scriptLib"/core/installations/kernel_linux
	#if [[ ! -e "$scriptLib"/core/installations/kernel_linux/linux-lts-server-amd64-debian.tar.gz ]]
	#then
		#cd "$scriptLib"/core/installations/

		#_wget_githubRelease_internal-core soaringDistributions/mirage335KernelBuild linux-lts-server-amd64-debian.tar.gz

		#mv -f linux-lts-server-amd64-debian.tar.gz kernel_linux/linux-lts-server-amd64-debian.tar.gz
		#cd "$scriptLib"/core/installations/kernel_linux
		#tar xf linux-lts-server-amd64-debian.tar.gz
	#fi

	_messageNormal '########## installations: 'linux-mainline-server
	mkdir -p "$scriptLib"/core/installations/kernel_linux
	if [[ ! -e "$scriptLib"/core/installations/kernel_linux/linux-mainline-server-amd64-debian.tar.gz ]]
	then
		cd "$scriptLib"/core/installations/

		_wget_githubRelease_internal-core soaringDistributions/mirage335KernelBuild linux-mainline-server-amd64-debian.tar.gz

		mv -f linux-mainline-server-amd64-debian.tar.gz kernel_linux/linux-mainline-server-amd64-debian.tar.gz
		cd "$scriptLib"/core/installations/kernel_linux
		#tar xf linux-mainline-server-amd64-debian.tar.gz
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
	


	# WARNING: May be obsolete, untested, or not recently maintained.

	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations BiosignalProcessor
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations LaserDemo
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations HF_Upconverter

	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations audioManager

	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations ChannelScanKit


	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations mouserTools


	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations OpenActuators

	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations C_CMake_Template


	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations huggingface_cli



	

	if ! [[ -e "$scriptLib"/core/installations/klipper ]]
	then
		cd "$scriptLib"/core/installations
		! _messagePlain_probe_cmd _gitBest clone --depth 1 --recursive git@github.com:Klipper3d/klipper.git && _core_FAIL
	fi
	! [[ -e "$scriptLib"/core/installations/klipper ]] && _core_FAIL 'missing: klipper'



	#if ! [[ -e "$scriptLib"/core/installations/kiauh ]]
	#then
		#cd "$scriptLib"/core/installations
		#! _messagePlain_probe_cmd _gitBest clone --depth 1 --recursive https://github.com/dw-0/kiauh.git && _core_FAIL
	#fi
	#! [[ -e "$scriptLib"/core/installations/kiauh ]] && _core_FAIL 'missing: kiauh'



	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/installations kiauh-automatic






	cd "$scriptLib"/core/installations
	if ! [[ -e "$scriptLib"/core/installations/anylabeling ]]
	then
		cd "$scriptLib"/core/installations
		! _messagePlain_probe_cmd mkdir -p "$scriptLib"/core/installations/anylabeling && _core_FAIL
		
		cd "$scriptLib"/core/installations/anylabeling
		#! wget https://github.com/soaringDistributions/anylabeling/releases/download/archive-v0.4.8/AnyLabeling-GPU.exe && _core_FAIL
		! wget https://github.com/vietanhdev/anylabeling/releases/download/v0.4.8/AnyLabeling-GPU.exe && _core_FAIL
		#! wget https://github.com/soaringDistributions/anylabeling/releases/download/archive-v0.4.8/AnyLabeling-Linux && _core_FAIL
		! wget https://github.com/vietanhdev/anylabeling/releases/download/v0.4.8/AnyLabeling-Linux && _core_FAIL
		#! wget https://github.com/soaringDistributions/anylabeling/releases/download/archive-v0.4.8/AnyLabeling-Linux-GPU && _core_FAIL
		! wget https://github.com/vietanhdev/anylabeling/releases/download/v0.4.8/AnyLabeling-Linux-GPU && _core_FAIL
		#! wget https://github.com/soaringDistributions/anylabeling/releases/download/archive-v0.4.8/AnyLabeling.exe && _core_FAIL
		! wget https://github.com/vietanhdev/anylabeling/releases/download/v0.4.8/AnyLabeling.exe && _core_FAIL
		
		
		cd "$scriptLib"/core/installations/anylabeling
		#! wget https://github.com/soaringDistributions/X-AnyLabeling/releases/download/archive-v2.3.6/X-AnyLabeling-CPU.exe && _core_FAIL
		! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v2.3.6/X-AnyLabeling-CPU.exe && _core_FAIL
		#! wget https://github.com/soaringDistributions/X-AnyLabeling/releases/download/archive-v2.3.6/X-AnyLabeling-GPU.exe && _core_FAIL
		! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v2.3.6/X-AnyLabeling-GPU.exe && _core_FAIL
		#! wget https://github.com/soaringDistributions/X-AnyLabeling/releases/download/archive-v2.3.6/X-Anylabeling-Linux-CPU && _core_FAIL
		! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v2.3.6/X-Anylabeling-Linux-CPU && _core_FAIL
		#! wget https://github.com/soaringDistributions/X-AnyLabeling/releases/download/archive-v2.3.6/X-Anylabeling-Linux-GPU && _core_FAIL
		! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v2.3.6/X-Anylabeling-Linux-GPU && _core_FAIL
		
		
		
		cd "$scriptLib"/core/installations/anylabeling
		! _messagePlain_probe_cmd _gitBest clone --depth 1 --recursive https://github.com/soaringDistributions/segment_anything-models && _core_FAIL
		
		cd "$scriptLib"/core/installations/anylabeling/segment_anything-models
		#! wget https://github.com/soaringDistributions/segment_anything-models/releases/download/archive/mobile_sam_20230629_quant.zip && _core_FAIL
		! wget https://huggingface.co/vietanhdev/segment-anything-onnx-models/blob/main/mobile_sam_20230629_quant.zip && _core_FAIL
		#! wget https://github.com/soaringDistributions/segment_anything-models/releases/download/archive/sam_vit_b_01ec64_quant.zip && _core_FAIL
		! wget https://huggingface.co/vietanhdev/segment-anything-onnx-models/blob/main/sam_vit_b_01ec64_quant.zip && _core_FAIL
		#! wget https://github.com/soaringDistributions/segment_anything-models/releases/download/archive/sam_vit_h_4b8939_quant.zip && _core_FAIL
		! wget https://huggingface.co/vietanhdev/segment-anything-onnx-models/blob/main/sam_vit_h_4b8939_quant.zip && _core_FAIL
		
		
		# sam-hq_vit_h_quant-r20231111
		cd "$scriptLib"/core/installations/anylabeling/segment_anything-models
		#! wget https://github.com/soaringDistributions/segment_anything-models/releases/download/archive-002/sam_hq_vit_h_decoder.onnx && _core_FAIL
		! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v2.0.0/sam_hq_vit_h_decoder.onnx && _core_FAIL
		#! wget https://github.com/soaringDistributions/segment_anything-models/releases/download/archive-002/sam_hq_vit_h_encoder_quant.onnx && _core_FAIL
		! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v2.0.0/sam_hq_vit_h_encoder_quant.onnx && _core_FAIL
		
		
		# lvm_sam_ssk_kvasir_vit_b-r20230810
		cd "$scriptLib"/core/installations/anylabeling/segment_anything-models
		#! wget https://github.com/soaringDistributions/segment_anything-models/releases/download/archive-002/sam-med2d_b.decoder.onnx && _core_FAIL
		! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam-med2d_b.decoder.onnx && _core_FAIL
		#! wget https://github.com/soaringDistributions/segment_anything-models/releases/download/archive-002/sam-med2d_b.encoder.onnx && _core_FAIL
		! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam-med2d_b.encoder.onnx && _core_FAIL
		
		
		
		#! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam_model_best_large_ssl_buidnewprocess.decoder.onnx && _core_FAIL
		#! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam_model_best_large_ssl_buidnewprocess.decoder.quant.onnx && _core_FAIL
		#! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam_model_best_large_ssl_buidnewprocess.encoder.onnx && _core_FAIL
		#! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam_model_best_large_ssl_buidnewprocess.encoder.quant.onnx && _core_FAIL
		#! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam_model_best_large_ssl_isiconlytrain.decoder.onnx && _core_FAIL
		#! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam_model_best_large_ssl_isiconlytrain.decoder.quant.onnx && _core_FAIL
		#! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam_model_best_large_ssl_isiconlytrain.encoder.onnx && _core_FAIL
		#! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam_model_best_large_ssl_isiconlytrain.encoder.quant.onnx && _core_FAIL
		#! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam_model_best_large_ssl_kvasir.decoder.onnx && _core_FAIL
		#! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam_model_best_large_ssl_kvasir.decoder.quant.onnx && _core_FAIL
		#! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam_model_best_large_ssl_kvasir.encoder.onnx && _core_FAIL
		#! wget https://github.com/CVHub520/X-AnyLabeling/releases/download/v0.2.0/sam_model_best_large_ssl_kvasir.encoder.quant.onnx && _core_FAIL
		
	fi
	
	
	
	
	



	if ! [[ -e "$scriptLib"/core/installations/maximize-build-space ]]
	then
		cd "$scriptLib"/core/installations
		! _messagePlain_probe_cmd _gitBest clone --depth 1 --recursive git@github.com:easimon/maximize-build-space.git && _core_FAIL
	fi
	! [[ -e "$scriptLib"/core/installations/maximize-build-space ]] && _core_FAIL 'missing: maximize-build-space'




	
	
	
	
	
	cd "$scriptLib"/core/infrastructure
	
	_ubDistFetch_gitBestFetch_github_distllc "$scriptLib"/core/infrastructure ubDistBuild

	_ubDistFetch_gitBestFetch_github_distllc "$scriptLib"/core/infrastructure ubDistFetch


	
	cd "$scriptLib"/core/infrastructure
	_ubDistFetch_gitBestFetch_github_mirage335-colossus "$scriptLib"/core/infrastructure ollama



	cd "$scriptLib"/core/infrastructure
	
	_ubDistFetch_gitBestFetch_github_mirage335-gizmos "$scriptLib"/core/infrastructure flightDeck

	_ubDistFetch_gitBestFetch_github_mirage335-gizmos "$scriptLib"/core/infrastructure kinematicBase-large
	
	_ubDistFetch_gitBestFetch_github_mirage335-gizmos "$scriptLib"/core/infrastructure tinyMakeLab



	# https://github.com/mirage335/gedaProduction/blob/a9525331749c5dbfba05c687395ccbdc2be1af6c/laserstencil/millproject
	#if ! [[ -e "$scriptLib"/core/infrastructure/pcb2gcode ]]
	#then
		#cd "$scriptLib"/core/infrastructure
		#! _messagePlain_probe_cmd _gitBest clone --depth 1 --recursive git@github.com:pcb2gcode/pcb2gcode.git && _core_FAIL
	#fi
	#! [[ -e "$scriptLib"/core/infrastructure/pcb2gcode ]] && _core_FAIL 'missing: pcb2gcode'
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure pcb2gcode

	
	
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

	#_ubDistFetch_gitBestFetch_github_mirage335-colossus "$scriptLib"/core/infrastructure ubiquitous_bash_bundle
	if ! [[ -e "$scriptLib"/core/infrastructure/ubiquitous_bash_bundle ]] && ! [[ -e "$scriptLib"/core/infrastructure/ubiquitous_bash_bundle.git ]]
	then
		cd "$scriptLib"/core/infrastructure
		! _messagePlain_probe_cmd _gitBest clone --depth 1 --bare git@github.com:mirage335-colossus/ubiquitous_bash_bundle.git && _core_FAIL
	fi
	! [[ -e "$scriptLib"/core/infrastructure/ubiquitous_bash_bundle ]] && ! [[ -e "$scriptLib"/core/infrastructure/ubiquitous_bash_bundle.git ]] && _core_FAIL 'missing: ubiquitous_bash_bundle'
	
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
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure credManager
	
	
	
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
	
	

	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure AppImages_ubiquitous

	
	
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

	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure gEDA_refdes_renumALL
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure webClient
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure zipTiePanel

	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure wirewrap_huge

	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure VR_Headset_Hanger
	
	
	#_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure aftermarket_8kX_hinge
	if ! [[ -e "$scriptLib"/core/infrastructure/aftermarket_8kX_hinge ]]
	then
		cd "$scriptLib"/core/infrastructure
		! _messagePlain_probe_cmd _gitBest clone --depth 1 --bare git@github.com:mirage335/aftermarket_8kX_hinge.git && _core_FAIL
	fi
	! [[ -e "$scriptLib"/core/infrastructure/aftermarket_8kX_hinge ]] && ! [[ -e "$scriptLib"/core/infrastructure/aftermarket_8kX_hinge.git ]] && _core_FAIL 'missing: aftermarket_8kX_hinge'


	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure Mirage335BiosignalAmp

	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure BiosignalSimulator

	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure LinearPSU

	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure 30MHzLowPass

	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure HVDC_Engine
	
	
	
	
	
	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure quickWriter



	
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure SuperhetPlanner
	_ubDistFetch_gitBestFetch_github_mirage335 "$scriptLib"/core/infrastructure SystemTemplate

	

	
	_ubDistFetch_gitBestFetch_github_mirage335-gizmos "$scriptLib"/core/infrastructure pumpCompanion
	_ubDistFetch_gitBestFetch_github_mirage335-gizmos "$scriptLib"/core/infrastructure puddleJumper
	


	_ubDistFetch_gitBestFetch_github_mirage335-special "$scriptLib"/core/infrastructure iconArt
	
	
	

	#mkdir -p "$scriptLib"/core/variant
	cd "$scriptLib"/core/variant
	
	_ubDistFetch_gitBestFetch_github_distllc "$scriptLib"/core/variant ubdist_dummy

	_ubDistFetch_gitBestFetch_github_distllc "$scriptLib"/core/variant ubdist_puddleJumper




	#mkdir -p "$scriptLib"/core/info
	cd "$scriptLib"/core/info
	
	_ubDistFetch_gitBestFetch_github_mirage335-gizmos "$scriptLib"/core/info aa_DAMAGE_CONTROL
	
	_ubDistFetch_gitBestFetch_github_mirage335-special "$scriptLib"/core/info issues


	mkdir -p "$scriptLib"/core
	cd "$scriptLib"/core

	#_ubDistFetch_gitBestFetch_github_mirage335-colossus "$scriptLib"/core cognition


	#mkdir -p "$scriptLib"/infrastructure
	#cd "$scriptLib"/core/infrastructure
	
	#_ubDistFetch_gitBestFetch_github_mirage335-colossus "$scriptLib"/core/infrastructure virtuousCritter


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





# ATTENTION: NOTICE: Specifically for core directories with both non-portable files (ie. python venv) and heavy dependencies (ie. '_getMost' ) .
# CAUTION: NOTICE: MUST install core directories (ie. any extraction of 'ubDistFetch_package') to ~/core before calling this function. 
_ubDistFetch_setup() {
	if [[ -e "$HOME"/core/infrastructure/quickWriter ]]
	then
		"$HOME"/core/infrastructure/quickWriter/quickWriter _setup_prog
	fi
}









_refresh_anchors() {
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_ubDistFetch.bat
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_ubDistFetch_package.bat
}
