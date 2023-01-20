var config = {
    dobet: {label: 'Live Mode', value: false, type: 'boolean'},
    
    dobetlabel: {label: 'Live Mode', type: 'title'},
    dobet: {label: '', value: false, type: 'radio',
      options: [
        {value: true, label: 'Yes'},
        {value: false, label: 'No'}
      ]
    },
    baseBet: {label: 'Starting Bet:', value: currency.minAmount, type: 'number'},
    baseBetPC: {label: 'Starting Bet in Percent:', value: 0.1, type: 'number'},
    maxBet: {label: 'Maximum Bet:', value: currency.maxAmount, type: 'number'},
    minBet: {label: 'Minimum Bet:', value: currency.minAmount, type: 'number'},
    basePayout: {label: 'Starting Payout:', value: 2, type: 'number'},
    maxPayout: {label: 'Maximum Payout:', value: 20.00, type: 'number'},
    minPayout: {label: 'Minimum Payout:', value: 1.01, type: 'number'},
    winRepeat: {label: 'Reset After Win Streak of:', value: 2000, type: 'number'},
    lossReset: {label: 'Reset After Loss Streak of:', value: 500, type: 'number'},
    waitForRed: {label: 'Reset After Loss Streak of:', value: 500, type: 'number'},
    moonBet: {label: 'Bet when awaiting moon:', value: currency.minAmount, type: 'number'},
    moonBetSeq: {label: 'Bet Sequense when awaiting moon:', value: "", type: 'text'},
    moonPayout: {label: 'Payout when awaiting moon:', value: 2, type: 'number'},
    moonPayoutSeq: {label: 'Payout Sequense when awaiting moon:', value: "", type: 'text'},
    moonPhase: {label: 'Moon Phase after X Games:', value: currency.minAmount, type: 'number'},
    

    onBetLossTitle: {label: 'Loss Bet Settings', type: 'title'},
    onBetLoss: {label: '', value: 'none', type: 'radio',
        options: [
            {value: 'none',label: 'Return to Starting Bet'},
            {value: 'add', label: 'Add to Bet'},
            {value: 'sub', label: 'Subtract From Bet'},
            {value: 'mul', label: 'Multiply Bet By'},
            {value: 'div', label: 'Divide Bet By'},
            {value: 'seq', label: 'Sequense Bet Multiplier'}
        ]
    },
    addBetLoss: { label: 'Increase Bet By:', value: 0, type: 'number' },
    subBetLoss: { label: 'Decrease Bet By:', value: 0, type: 'number' },
    mulBetLoss: { label: 'Multiply Bet By:', value: 2, type: 'number' },
    divBetLoss: { label: 'Divide Bet By:', value: 2, type: 'number' },
    seqBetLoss: { label: 'Sequense Bet Multiplier', value: 500, type: 'text'},

    onPayoutLossTitle :{label: 'Loss Payout Settings', type: 'title'},
    onPayoutLoss: {label: '', value: 'none', type: 'radio',
        options: [
            {value: 'none', label: 'Return to Starting Payout'},
            {value: 'add', label: 'Add to Payout'},
            {value: 'sub', label: 'Subtract From Payout'},
            {value: 'mul', label: 'Multiply Payout By'},
            {value: 'div', label: 'Divide Payout By'},
            {value: 'seq', label: 'Sequense Payout'}
        ]
    },
    addPayoutLoss: { label: 'Increase Payout By:', value: 1.02, type: 'number' },
    subPayoutLoss: { label: 'Decrease Payout By:', value: 0, type: 'number' },
    mulPayoutLoss: { label: 'Multiply Payout By:', value: 1, type: 'number' },
    divPayoutLoss: { label: 'Divide Payout By:', value: 2, type: 'number' },
    seqPayoutLoss: {label: 'Sequense Payout', value: 500, type: 'text'},

    onBetWinTitle: {label: 'Win Bet Settings', type: 'title'},
    onBetWin: {label: '', value: 'none', type: 'radio',
        options: [
            {value: 'none', label: 'Return to Starting Bet'},
            {value: 'add', label: 'Add to Bet'},
            {value: 'sub', label: 'Subtract From Bet'},
            {value: 'mul', label: 'Multiply Bet By'},
            {value: 'div', label: 'Divide Bet By'}
        ]
    },
    addBetWin: { label: 'Increase Bet By:', value: 0, type: 'number' },
    subBetWin: { label: 'Decrease Bet By:', value: 0, type: 'number' },
    mulBetWin: { label: 'Multiply Bet By:', value: 1, type: 'number' },
    divBetWin: { label: 'Divide Bet By:', value: 1, type: 'number' },

    onPayoutWinTitle :{label: 'Win Payout Settings', type: 'title'},
    onPayoutWin: {label: '', value: 'none', type: 'radio',
        options: [
            {value: 'none', label: 'Return to Starting Payout'},
            {value: 'add', label: 'Add to Payout'},
            {value: 'sub', label: 'Subtract From Payout'},
            {value: 'mul', label: 'Multiply Payout By'},
            {value: 'div', label: 'Divide Payout By'}
        ]
    },
    addPayoutWin: { label: 'Increase Payout By:', value: 0, type: 'number' },
    subPayoutWin: { label: 'Decrease Payout By:', value: 0, type: 'number' },
    mulPayoutWin: { label: 'Multiply Payout By:', value: 2, type: 'number' },
    divPayoutWin: { label: 'Divide Payout By:', value: 1, type: 'number' }
}

function main(){
    var BCCrash = {
        dobet: config.dobet.value,
        LogObject: function(data){
            Object.keys(data).forEach((j, i) => { 
                log.success(j + ": " + data[j]);
            });
            //log.success(Object.keys(data));
        }
    }
    
    game.onBet = function () {
        if(BCCrash.dobet){
            game.bet(1, 1.01).then(
                function (payout){
                }
            )
        }
    }
    
    engine.on('GAME_ENDED', function (data){
        //BCCrash.LogObject(currency);
        // log.success(data.keys); 
        // log.success(data.gameId); 
        // log.success(data.hash);
        log.success(data.odds);
        // log.success(data.crash);
        // log.success(data.cashedAt);
        // log.success(data.wager);
    });
}