var config = {}
function main(){
    engine.on('GAME_ENDED', function (data){
        log.info(data.odds)
        console.log(data.odds)
    });
}