cd /d "%~dp0"
git log --since="last month" --pretty=format:'%%h,%%an,%%ar,%%s' > commit_logs.csv