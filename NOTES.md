# implementation notes

* main backup server has rouge installed
* main backup server includes configuration in YAML
	* our public/private ssh key
	* which hosts to connect to and backup
		* `username`
		* `hostname`
		* which files to backup (including exclusions[`--exclude=PATTERN` - exclude files matching PATTERN] and exemptions[`--include=PATTERN` - don't exclude files matching PATTERN])
		* [optional] extra `rsync` flags, such as `-z`/`--compress`
* default `rsync` options: `-vh -aR --delete --delete-excluded` (followed by the optional extra flags specified per-host)
* don't backup a rouge backups directory (detected by some hidden file, like `.rouge_backupLocation`), unless the configuration block for the host specifies that we should
* `git add -A`

# possible future enhancements

* better support for backing up git repositories (full or bare), especially local file changes
	* this might be accomplished well by just finding any folder named `.git` and temporarily renaming it to something else (like `rouge_git`, or something), and then having some script to parse it back
	* it might also be helpful to add a special file in the `.git` folder to help us recognize our renamed folder as a renamed `.git` folder and not just a happy coincidence (although we could just keep that as an "intentional limitation" to keep things simple)
	* also, files like `.gitignore` definitely need to be renamed, so they don't conflict (so really, all of `.git*` needs to be renamed to `rouge_git*`)
* saving metadata (such as file owners) -- [metastore][metastore]?
* saving hard links (much more difficult to do; might want to look at information about how rsync detects them)
	* could be done by using `--hard-links` in rsync, then by checking inode numbers and keeping a separate list of files which need to be hardlinked, only backing up one of them and having whatever restore process gets created recreate them properly
* some way to easily restore files when a system which has died is "resurrected" (would obviously require saving metadata)
* support for databases (MongoDB, MySQL, etc.)

[metastore]: http://david.hardeman.nu/software.php#metastore
