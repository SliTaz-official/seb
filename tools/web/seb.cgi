#!/bin/sh
#
# seb.cgi: SliTaz Embedded Builder CGI interface. Invoking seb to build
# a custom OS in the current dir or the one set in the work= config variable.
# The webserver must be run by root, so we use Busybox httpd to serve on
# a custom port and for localhost only (see seb httpd.conf).
#
# Example: # cd path/to/os; seb -w
#
. /usr/lib/slitaz/httphelper.sh
header

. /lib/libseb.sh
work="$(pwd)"
packages="/usr/share/seb/packages"
export output=html

# Everything preformatted for a cmdline style output
cat << EOT
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<title>SliTaz Embedded Builder</title>
	<style type="text/css">
		h1 { color: #888; font-size: 140%; } .info { color: #800057; }
		hr { border: 1px solid #ddd; } .pkg { color: #800057; padding: 0 20px 0 0; }
	</style>
</head>
<h1>SliTaz Embedded Builder</h1>
<pre>
<a href="./seb.cgi">Summary</a> \
<a href="./seb.cgi?build">Build</a> \
<a href="./seb.cgi?packages">Packages</a> \
<a href="./seb.cgi?emulate">Emulate</a> \
<a href="./seb.cgi?debug">Debug</a> \
<a href="./seb.cgi?help">Help</a>

EOT

case " $(GET) " in

	*\ help\ *)      seb | sed '1,2d' ;;
	*\ build\ *)     seb -b ;;
	*\ emulate\ *)   seb -e ;;
	*\ debug\ *)     seb env; seb testsuite ;;
	*\ packages\ *)
		title "Seb packages"
		IFS=":"
		echo "<table>"
		ls ${packages} | while read pkg; do
			. ${packages}/${pkg}
			echo "<tr><td class='pkg'>$pkg</td><td>$desc</td></tr>"
		done; unset IFS
		echo "</table><hr />" ;;
	
	*)
		title "Seb summary"
		echo "Work path   : <span class='info'>$work</span>"
		if [ -d "$work/rootfs" ]; then
			cat << EOT
Rootfs size  : <span class='info'>$(du -sh $work/rootfs | awk '{print $1}')</span>
Rootiso size : <span class='info'>$(du -sh $work/rootiso | awk '{print $1}')</span>
EOT
		else
			echo "Seb OS      : Not built yet!"
		fi; footer ;;
esac

cat << EOT
</pre>
</body>
</html>
EOT
exit 0
