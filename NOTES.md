# implementation notes

* main backup server has rouge installed
* main backup server includes configuration in YAML
	* our public/private ssh key
	* which hosts to connect to and backup
		* `username`
		* `hostname`
		* which files to backup (including exclusions[`--exclude=PATTERN` - exclude files matching PATTERN] and exemptions[`--include=PATTERN` - don't exclude files matching PATTERN])
		* [optional] extra `rsync` flags, such as `-z`/`--compress`
* default `rsync` options: `-vh -aP --delete --delete-excluded` (followed by the optional extra flags specified per-host)

# possible future enhancements

* better support for backing up git repositories (full or bare), especially local file changes
* saving metadata (such as file owners)
* some way to easily restore files when a system which has died is "resurrected" (would require saving metadata)
* support for MongoDB databases
* support for MySQL databases
