LBlue='\033[1;34m'
NC='\033[0m' # No Color
iHome="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $iHome

if [ -z != $1 ]
	then
	
	exit 0
fi

echo "ERROR Nothing to do. $0"
exit 2