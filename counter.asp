. C:\scripts\invoke-Sqlcmd2.ps1
$logpath = "F:\shadowbane\Shadowbane - RiF\Logs"
$logname = "mychat2.txt"
$loginfo = ""
#$loginfo = get-content $logpath\$logname | select-string -pattern "\[PvP\]"
$loginfo = get-content $logpath\$logname -delimiter `n | select-string -pattern "was killed by" | select-string -pattern "\[PvP\]"
clear-content $logpath\$logname

#get each element delimeted in arrays
$result = foreach ($entry in $loginfo) {$entry -replace '^(.*?)\[PvP\] ',''}
$result = foreach ($entry in $result) {$entry -replace 'the promising ',''}
$result = foreach ($entry in $result) {$entry -replace 'the LEGENDARY ',''}
$result = foreach ($entry in $result) {$entry -replace 'the GODLIKE ',''}
$result = foreach ($entry in $result) {$entry -replace 'the HEROIC ',''}
$result = foreach ($entry in $result) {$entry -replace 'the MASSACRIST ',''}
$result = foreach ($entry in $result) {$entry -replace 'the UNTOUCHABLE ',''}
$result = foreach ($entry in $result) {$entry -replace 'the EXALTED ',''}
$result = foreach ($entry in $result) {$entry -replace 'the IMMORTAL ',''}
$result = foreach ($entry in $result) {$entry -replace ' the innocent',''}
$result = foreach ($entry in $result) {$entry -replace ' of (.*?)was killed by ',','}
$result = foreach ($entry in $result) {$entry -replace ' was killed by ',','}
$result = foreach ($entry in $result) {$entry -replace ' of (.*?)$',''}
$kills = foreach ($entry in $result) {$entry -replace '^(.*?)\,',''}
$deaths = foreach ($entry in $result) {$entry -replace '\,(.*?)$',''}
foreach ($kill in $kills){if ($kill -match '^+[a-zA-Z0-9]$') {$sql = "IF EXISTS (SELECT 1 FROM kdcount WHERE name='$kill') UPDATE kdcount SET kills=kills + 1 WHERE [name]='$kill' ELSE INSERT INTO kdcount (name,kills) VALUES ('$kill',1)";Invoke-Sqlcmd2 -ServerInstance DARKKNIGHT\SQLEXPRESS -Database testdb -Query $sql}}
foreach ($death in $deaths){if ($death -match '^+[a-zA-Z0-9]$') {$sql = "IF EXISTS (SELECT 1 FROM kdcount WHERE name='$death') UPDATE kdcount SET deaths=deaths + 1 WHERE [name]='$death' ELSE INSERT INTO kdcount (name,deaths) VALUES ('$death',1)";Invoke-Sqlcmd2 -ServerInstance DARKKNIGHT\SQLEXPRESS -Database testdb -Query $sql}}
