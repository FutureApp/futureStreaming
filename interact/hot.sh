LBlue='\033[1;34m'
NC='\033[0m' # No Color
iHome="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $iHome

if [ "$1" == "mongo" ]
	then
    bash ./fu_service_functions.sh "kill all container"
	docker build -t futureapplications/mongodb-v3 ../images/mongo/.
	cd ../images/mongo
    docker-compose up
	cd $iHome
	exit 0
fi