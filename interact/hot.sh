LBlue='\033[1;34m'
NC='\033[0m' # No Color
iHome="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $iHome


if [ "$1" == "start mongo" ]
	then
	sudo docker build -t futureapplications/streaming-mongo ../images/mongo/.
	exit 0
fi