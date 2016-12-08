LBlue='\033[1;34m'
NC='\033[0m' # No Color
iHome="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $iHome


if [ "$1" == "mongo" ]
	then
    bash ./fu_service_functions.sh "kill all container"
	docker build -t futureapplications/streaming-mongo ../images/mongo/.
    docker run -d -p 8080:8080 --name "mongo" -h  "mongo"  futureapplications/streaming-mongo
	exit 0
fi