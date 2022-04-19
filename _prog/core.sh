##### Core

# "$1" ~= "$scriptLib"/core/infrastructure
# "$2" ~= git@github.com:mirage335/ubiquitous_bash.git
# "$3" ~= ubiquitous_bash
# "$4" ~= HEAD (optional)
_ubDistFetch_gitBestFetch() {
	[[ -e "$1"/"$3" ]] && return 0
	
	local functionEntryPWD
	functionEntryPWD="$PWD"
	
	local currentCheckout
	currentCheckout="$4"
	[[ "$currentCheckout" == "" ]] && currentCheckout=HEAD
	
	! _messagePlain_probe_cmd mkdir -p "$1"  && _messageFAIL
	! _messagePlain_probe_cmd cd "$1" && _messageFAIL
	#_gitBest clone --depth 1 --recursive "$2"
	if [[ "$4" == "" ]] || [[ "$4" == "HEAD" ]] || [[ "$4" == "main" ]] || [[ "$4" == "master" ]]
	then
		_gitBest clone --depth 1 "$2"
	elif [[ $(_safeEcho_newline "$4" | wc -c | tr -dc '0-9') -ge 40 ]]
	then
		_gitBest clone "$2"
	fi
	#[[ ! -e "$1"/"$3" ]] && _messageFAIL
	! _messagePlain_probe_cmd cd "$1"/"$3" && _messageFAIL
	! _messagePlain_probe_cmd git checkout "$currentCheckout" && _messageFAIL
	if [[ "$4" == "" ]] || [[ "$4" == "HEAD" ]] || [[ "$4" == "main" ]] || [[ "$4" == "master" ]]
	then
		! _messagePlain_probe_cmd git pull && _messageFAIL
	elif [[ $(_safeEcho_newline "$4" | wc -c | tr -dc '0-9') -ge 40 ]]
	then
		_messagePlain_probe_cmd git pull
	fi
	! _messagePlain_probe_cmd git submodule update --init --depth 1 --recursive && _messageFAIL
	
	cd "$functionEntryPWD"
}


_ubDistFetch() {
	local functionEntryPWD
	functionEntryPWD="$PWD"
	_start
	
	# If directory exists, pull updates instead of deleting and recreating.
	export safeToDeleteGit="true"
	#_safeRMR "$scriptLib"/core/infrastructure
	#_safeRMR "$scriptLib"/core/installations
	
	mkdir -p "$scriptLib"/core/infrastructure
	mkdir -p "$scriptLib"/core/installations
	
	
	
	
	cd "$scriptLib"/core/installations
	
	_messageNormal '########## installations: 'copyleft
	[[ ! -e gpl-3.0.txt ]] && wget https://www.gnu.org/licenses/gpl-3.0.txt
	[[ ! -e agpl-3.0.txt ]] && wget https://www.gnu.org/licenses/agpl-3.0.txt
	
	
	_messageNormal '########## installations: 'pcb-ioAutorouter
	_ubDistFetch_gitBestFetch "$scriptLib"/core/installations git@github.com:mirage335/pcb-ioAutorouter.git pcb-ioAutorouter
	
	
	if ! [[ -e "$scriptLib"/core/installations/pstoedit-3.75 ]]
	then
		#wget 'https://phoenixnap.dl.sourceforge.net/project/pstoedit/pstoedit/3.75/pstoedit-3.75.tar.gz' -O pstoedit-3.75.tar.gz
		wget 'https://sourceforge.net/projects/pstoedit/files/pstoedit/3.75/pstoedit-3.75.tar.gz/download' -O pstoedit-3.75.tar.gz
		! _messagePlain_probe_cmd tar xf pstoedit-3.75.tar.gz && _messageFAIL
		rm -f pstoedit-3.75.tar.gz
	fi
	! [[ -e "$scriptLib"/core/installations/pstoedit-3.75 ]] && _messageFAIL
	
	
	
	
	
	
	cd "$scriptLib"/core/infrastructure
	
	
	_messageNormal '########## infrastructure: 'moby
	if ! [[ -e "$scriptLib"/core/infrastructure/moby ]]
	then
		wget 'https://codeload.github.com/moby/moby/zip/3e1df952b7d693ac3961f492310852bdf3106240' -O moby-3e1df952b7d693ac3961f492310852bdf3106240.zip
		unzip moby-3e1df952b7d693ac3961f492310852bdf3106240.zip
		rm -f moby-3e1df952b7d693ac3961f492310852bdf3106240.zip
		mv -f moby-3e1df952b7d693ac3961f492310852bdf3106240 moby
	fi
	_ubDistFetch_gitBestFetch "$scriptLib"/core/infrastructure git@github.com:moby/moby.git moby 3e1df952b7d693ac3961f492310852bdf3106240
	
	_messageNormal '########## infrastructure: 'ubiquitous_bash
	_ubDistFetch_gitBestFetch "$scriptLib"/core/infrastructure git@github.com:mirage335/ubiquitous_bash.git ubiquitous_bash
	
	
	_messageNormal '########## infrastructure: 'mirage335_documents
	_ubDistFetch_gitBestFetch "$scriptLib"/core/infrastructure git@github.com:mirage335/mirage335_documents.git mirage335_documents
	
	
	
	
	
	
	cd "$functionEntryPWD"
	_stop
}

_refresh_anchors() {
	cp -a "$scriptAbsoluteFolder"/_anchor.bat "$scriptAbsoluteFolder"/_ubDistFetch.bat
}
