var config = {
    dobetlabel: {label: 'Live Mode', type: 'title'},
    dobet: {label: '', value: false, type: 'radio',
      options: [
        {value: true, label: 'Yes'},
        {value: false, label: 'No'}
      ]
    },
    betPerCentlabel: {label: 'Starting Bet by Percent', type: 'title'},
    dobetPerCent: {label: '', value: false, type: 'radio',
      options: [
        {value: true, label: 'Yes'},
        {value: false, label: 'No'}
      ]
    },
    baseBet: {label: 'Starting Bet:', value: currency.minAmount, type: 'number'},
    baseBetPercent: {label: 'Starting Bet in Percent:', value: 0.1, type: 'number'},
    maxBet: {label: 'Maximum Bet:', value: currency.maxAmount, type: 'number'},
    minBet: {label: 'Minimum Bet:', value: currency.minAmount, type: 'number'},

    basePayout: {label: 'Starting Payout:', value: 2, type: 'number'},
    maxPayout: {label: 'Maximum Payout:', value: 20.00, type: 'number'},
    minPayout: {label: 'Minimum Payout:', value: 1.01, type: 'number'},

    winRepeat: {label: 'Reset After Win Streak of:', value: 2, type: 'number'},
    lossReset: {label: 'Reset After Loss Streak of:', value: 8, type: 'number'},
    waitForRed: {label: 'Wait for Red:', value: 1, type: 'number'},

    moonSettingsTitle :{label: 'Moon Settings', type: 'title'},
    moonBet: {label: 'Bet when awaiting moon:', value: currency.minAmount, type: 'number'},
    moonBetPercent: {label: 'Starting Bet in Percent:', value: 0.1, type: 'number'},
    moonBetSeq: {label: 'Bet Sequense Multiplier when awaiting moon:', value: "", type: 'text'},
    moonPayout: {label: 'Payout when awaiting moon:', value: 12, type: 'number'},
    moonPayoutSeq: {label: 'Payout Sequense when awaiting moon:', value: "", type: 'text'},
    moonPhase: {label: 'Moon Phase after X Games:', value: 50, type: 'number'},

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
    // var currency = {
    //     minAmount: 1,
    //     maxAmount: 2000,
    //     amount: 10000,
    //     currencyName: "JB"
    // }
    var BCC = {
        dobet: config.dobet.value,
        placebet: false,
        wallet: currency.amount,
        currencyNCS: {
            JB: 4,
            BCD: 6
        },
        Odds: {
            all: [],
            temp: [1.1, 2.44, 7.45, 1.56, 1.55, 3.74, 6.42, 7.49, 1.9, 3.18, 1.76, 2.07, 2.41, 1.55, 1.92, 11.81, 13.71, 1.05, 1.27, 1.77, 2.82, 2.78, 1.86, 1.24, 1.58, 1.97, 1.99, 7.9, 1.1, 114.21, 7.16, 1.24, 1.31, 9.04, 3.24, 1.4, 5.56, 3.78, 1, 1.66, 1.41, 1.03, 3.57, 2.08, 7.53, 1.18, 1.01, 1.17, 2.33, 1.78, 1.69, 2.58, 28.12, 2.81, 1.16, 12.11, 6.55, 1.91, 1.36, 1.12, 17.34, 2.19, 1.7, 2.47, 2.96, 22.79, 7.98, 11.34, 1.02, 1, 1.09, 1.83, 2.25, 17.58, 1.28, 43.55, 1.22, 1.42, 1.4, 1.63, 2.58, 1.32, 31.36, 1.8, 1.07, 3.02, 2.23, 9.39, 1.54, 1.24, 3.13, 4.1, 1.12, 1.06, 1.56, 1.85, 1.16, 1.92, 1.26, 8.45, 82.88, 2.41, 3.15, 1.87, 2.18, 5.05, 1.77, 2.71, 1.19, 1.45, 1.38, 1.13, 9.99, 1.08, 1.82, 13.34, 1.99, 1.69, 16.97, 1, 2.36, 1.87, 1.39, 1.07, 2.2, 1.26, 1.19, 2.32, 4.15, 13.18, 1.43, 1.05, 1.4, 3.8, 1.03, 3.75, 13.5, 7.7, 1.93, 2.11, 4.05, 1.07, 2.3, 1.01, 1.14, 1.95, 1.27, 4.96, 2.56, 1.72, 6.61, 2.19, 1.56, 1.59, 11.01, 1.48, 1.02, 1.11, 1, 1.25, 2.01, 1.43, 2.53, 1.06, 1.13, 1.23, 1.97, 6.43, 1.14, 2.58, 3.11, 2.16, 1.25, 9.93, 2.43, 6.91, 11.53, 3.78, 1.27, 4.12, 8.34, 8.8, 1.37, 2.62, 1.13, 5.34, 1.47, 1.18, 2.87, 2.23, 1.43, 2044.07, 1.4, 1.06, 3.18, 1.35, 1.51, 1.36, 7.22, 1.07, 1.01, 1.15, 1.2, 7.19, 11.05, 3.92, 1.06, 1.01, 1.11, 1.52, 1.08, 1.52, 1.38, 2.35, 1.42, 1.54, 4.43, 33.38, 12.1, 3.29, 1.42, 1, 12.74, 12.87, 3.18, 35.19, 4.46, 1.52, 4.97, 1.37, 1.49, 1.78, 18.41, 1.18, 2.81, 2.88, 1, 2.32, 55.18, 2.25, 1.31, 1.34, 1.96, 5.48, 1.03, 1.05, 1.82, 1.13, 1, 4.52, 5.46, 1.23, 3.8, 1.17, 22.77, 1.25, 1.34, 2.73, 1.64, 1.53, 1.95, 2.19, 169.52, 1.6, 3.65, 365.46, 2.18, 2.19, 3.63, 1.18, 1.4, 14.49, 2.25, 1.05, 1.16, 1, 99.04, 41.59, 163.48, 1.31, 1.85, 10.14, 8.97, 2.8, 2.9, 2.17, 1.15, 1.54, 1.42, 1.01, 1.16, 1.22, 1.42, 3.41, 1.92, 1.14, 1.05, 1, 2.8, 2.5, 1.46, 4.85, 1.83, 5.21, 1.79, 2.77, 1.61, 1.03, 1.14, 1.13, 4.46, 2.9, 5.88, 4.37, 2.2, 6.4, 1.05, 7.28, 1.96, 3.79, 1.35, 1.22, 1.05, 1.43, 1.31, 8.22, 1.06, 1.13, 1.22, 1, 8.78, 2.14, 8.03, 1.49, 4.75, 9.82, 1.12, 1.21, 3.36, 64, 3.17, 1, 7.46, 1.18, 6.49, 1.75, 2.27, 1.34, 102.6, 1.36, 1, 1.78, 1.21, 3.31, 3.4, 1.2, 1.26, 2.49, 1.48, 4.93, 6.88, 2.36, 1.02, 4.13, 1.32, 1.1, 1.98, 1.66, 1.95, 2.15, 3.74, 1.32, 1.14, 5.19, 1.6, 1.19, 2.4, 1.96, 1.1, 2.62, 2.84, 4.76, 1.66, 1.01, 240.45, 8.96, 2.62, 1.12, 4.5, 2.94, 8.58, 8.45, 9.48, 1.18, 2.55, 2.97, 14.21, 2.88, 3.63, 2.62, 1.26, 2.02, 16.49, 1.61, 1.2, 1.1, 35.84, 1.18, 4.25, 1.77, 1.32, 6.99, 1.69, 2.81, 1.63, 1.03, 1.38, 3.81, 2.09, 1, 1.21, 2.41, 2.75, 3.12, 1.08, 1.27, 32.39, 1.27, 1.23, 1.39, 1.71, 1.28, 1.65, 6.05, 13.54, 114.63, 5.03, 4.79, 1.43, 1.05, 2.58, 1.39, 3.36, 4.42, 1.02, 2.29, 1.73, 1.1, 2.27, 25.83, 2.05, 510.43, 1.02, 16.76, 1.23, 19.72, 1.42, 1.09, 2.08, 2.68, 1.43, 1.27, 104.17, 1.04, 1.88, 7.13, 1.41, 1.25, 1.27, 1.26, 1.18, 1.87, 2, 1.23, 1.45, 1.06, 2.11, 4.39, 1.75, 6.26, 2.26, 13.73, 1.48, 1.25, 1.14, 3.12, 2.99, 2.16, 1.27, 1.34, 1.14, 1.37, 1.56, 4.42, 1.61, 1.21, 8.33, 1.96, 1, 1.55, 1.29, 1.14, 2.43, 8.63, 2.58, 3.09, 2.66, 18.29, 22.8, 12.86, 1.89, 275.99, 3.19, 3.12, 2.23, 1, 1.72, 1.1, 1.74, 1.17, 1.32, 1.6, 1.69, 1.14, 2.42, 13.04, 63.9, 1.41, 2.21, 1.65, 1.42, 1.24, 2.17, 1.01, 1.57, 5.01, 24.7, 1.23, 5.75, 1.39, 2.34, 10.82, 1.66, 12.68, 6.9, 5.37, 5.53, 1.47, 1.37, 2.48, 2.85, 5.45, 4.62, 1.53, 1.07, 1.36, 1.27, 1.14, 4.29, 29.2, 2.65, 1.11, 1.37, 1.45, 1, 1.79, 1.47, 1.2, 1, 2.26, 9.27, 1.31, 2.2, 1.03, 7.11, 1.27, 1.72, 6.67, 9.34, 2.98, 1.56, 1.09, 1.78, 13.06, 1.01, 1.47, 1.1, 1.43, 37.39, 14.75, 1.22, 2.52, 10.78, 5.75, 1.26, 1.45, 1.62, 9.56, 1.3, 1.98, 2.23, 223.25, 3.43, 2.7, 1.11, 1.01, 5.31, 6.64, 1.09, 24.6, 1.23, 1.95, 1.8, 1.73, 1.22, 1.06, 1.07, 1.11, 1.2, 1.4, 1.67, 1.25, 1.1, 13.87, 3.28, 1, 1.56, 1.34, 1.97, 1.03, 1.47, 2.11, 4.04, 19.27, 1.2, 13.31, 1.24, 3.17, 1.54, 1.15, 1.41, 1.95, 1.31, 15.57, 2.55, 1.45, 6.64, 1.97, 5.95, 1.16, 1.22, 1.41, 1.28, 2.72, 1.08, 1.06, 1.66, 4.17, 9.13, 1.53, 1.72, 6.78, 7.61, 1.04, 1.38, 2.78, 4.18, 1, 1.29, 3.22, 169.17, 1.84, 1.1, 1.45, 2.08, 2.95, 1.04, 3, 1.99, 3.68, 1.16, 1.85, 1.44, 1.92, 46.96, 3.33, 4.59, 15.94, 1.42, 1.03, 2.13, 1.78, 1.34, 2.1, 1.37, 31.19, 1.55, 1.3, 10.05, 1.92, 1.32, 3.49, 2.53, 1.41, 4.01, 1.02, 31.73, 3.41, 5.26, 1.65, 141.34, 1.9, 1.91, 1.07, 2.15, 3.15, 1.88, 52.83, 1, 1.43, 2.27, 1.64, 3.21, 36.07, 1.88, 2.74, 20.47, 1.12, 2.85, 1.22, 1.78, 4.5, 1.4, 1.17, 11.69, 3.62, 6.51, 1.43, 1.06, 2.85, 2.26, 72.14, 2.35, 2.64, 1.77, 6.13, 2.09, 1.28, 1.44, 1.7, 4.04, 2.39, 15.23, 1.6, 1.17, 2.62, 1.09, 2.7, 2.51, 3.48, 2.54, 9, 66.88, 2.28, 1.05, 1.6, 7.03, 1.29, 1.19, 1.15, 1.61, 5.28, 1.32, 9.22, 21.37, 14.05, 1.55, 1.22, 1.41, 2.35, 1.31, 6.36, 1.09, 1.2, 3.04, 1.16, 1.21, 1.55, 1.58, 1.96, 3.9, 1.22, 1.29, 2.58, 2.34, 17.59, 1.22, 4.54, 1.61, 1.2, 2.36, 9.69, 1.11, 2.58, 1.14, 12.92, 2.44, 1.88, 6.22, 2.45, 2.84, 3.71, 2.68, 1.2, 17.9, 2.41, 47, 1.52, 2.32, 4.54, 1.37, 1.85, 1.19, 3.88, 1.32, 2.89, 2.14, 7.92, 1.31, 1.36, 1.22, 1.94, 1.16, 2.77, 7.5, 7, 1.04, 1.18, 2.83, 3.82, 8.1, 1.66, 1.36, 1.28, 1.74, 1.17, 1.57, 1.38, 1.5, 1.92, 3.23, 6.89, 2.15, 1.77, 9.68, 1.29, 6.62, 3.3, 5.73, 2.75, 3.07, 1.15, 2.69, 9.72, 1.16, 36.54, 2.13, 30.53, 5.82, 1.44, 1.46, 1.12, 4.69, 3.44, 259.12, 3.72, 7.28, 2.19, 1.72, 1.37, 1.5, 5.22, 5.49, 8.23, 3.5, 3.09, 1.53, 17.94, 4.88, 4.95, 2.16, 1.35, 4.45, 2.11, 1.51, 3.02, 1.09, 5.64, 3.52, 3.08, 4.52, 2.81, 3.5, 1.25, 29.97, 3.13, 6.2, 1.7, 2.68, 2.1, 13.45, 1.15, 1.55, 6.71, 11.2, 1.36, 1.3, 6.76, 2.92, 2.09, 1.41, 3.68, 1.02, 1.04, 9.28, 3.89, 3.76, 1.35, 9.88, 3.76, 1.37, 34.16, 1.05, 2.51, 1.09, 1.17, 1.53, 1.33, 3.36, 1.46, 2.75, 1.16, 1.16, 2.6, 1.48, 1.46, 1.03, 6.12, 3.01, 16.1, 7.09, 7.21, 1.18, 1.45, 2.8, 18.62, 1.22, 1.03, 1.92, 2.08, 3.7, 3.07, 1.24, 2.01, 4.64, 1.03, 1.22, 1.01, 1.05, 2.85, 1.22, 2.51, 1.32, 7.93, 1.44, 9.67, 10.46, 1.34, 2.09, 2.05, 2.63, 1.44, 1.81, 5.55],
            current: 1.0
        },
        counter: {
            now:{
                win: 0,
                loss: 0,
                red: 0,
                green: 0,
                noyellow: 0
            },
            all:{
                win: 0,
                loss: 0,
                red: 0,
                green: 0,
                yellow: 0
            }
        },
        Bet: {
            base: config.baseBet.value, 
            current: config.baseBet.value,
            Win: config[(`${config.onBetWin.value}BetWin`)].value,
            Loss: config[(`${config.onBetLoss.value}BetLoss`)].value
        },
        Payout: {
            base: config.basePayout.value, 
            current: config.basePayout.value,
            Win: config[(`${config.onPayoutWin.value}PayoutWin`)].value,
            Loss: config[(`${config.onPayoutLoss.value}PayoutLoss`)].value
        },
        SetBetBase: function(){
            if(config.dobetPerCent.value){
                BCC.Bet.base = (currency.amount / 100 * config.baseBetPercent.value).toFixed(BCC.NCS("Bet")-1)
            }
        },
        InitVars: function(){
            if(config.onBetLoss.value == "seq"){
                BCC.Bet.Loss = BCC.Bet.Loss.split(BCC.GetSeqSepartor(BCC.Bet.Loss));
            }
            if(config.onPayoutLoss.value == "seq"){
                BCC.Payout.Loss = BCC.Payout.Loss.split(BCC.GetSeqSepartor(BCC.Payout.Loss));
                BCC.Payout.Loss.forEach((str, index) => { 
                    BCC.Payout.Loss[index] = parseFloat(str)
                });
            }
            BCC.SetBetBase()
        },
        GetSeqSepartor: function(seq){
            var separators = ['-', '/', ',', ' ']
            var returning = ""
            separators.forEach((str, index, arr) => { 
                if(seq.includes(str)){
                    returning = str;
                  	arr.length = index + 1
                }
            });
            return returning
        }, 
        NCS: function(type) {
            if(type == "Bet"){
                return BCC.currencyNCS[currency.currencyName]
            }
            return 2
        },
        SetOdds: function(odds){
            BCC.Odds.current = odds
            BCC.Odds.all.push(odds)
        },
        SetCounters: function(){
            if(BCC.placebet){
                if(BCC.Odds.current >= BCC.Payout.current){
                    BCC.counter.now.win++
                    BCC.counter.all.win++
                    BCC.counter.now.loss = 0
                    BCC.wallet += (BCC.Bet.current * BCC.Payout.current).toFixed(BCC.NCS("Bet"))
                }
                else{
                    BCC.counter.now.loss++
                    BCC.counter.all.loss++
                    BCC.counter.now.win = 0
                    BCC.wallet -= (BCC.Bet.current).toFixed(BCC.NCS("Bet"))
                }
            }
            else{
                BCC.counter.now.loss = 0
                BCC.counter.now.win = 0
            }
            if(BCC.Odds.current < 2){
                BCC.counter.now.red++
                BCC.counter.all.red++
                BCC.counter.now.noyellow++
                BCC.counter.now.green = 0
            }
            else if(BCC.Odds.current >= 10){
                BCC.counter.now.green++
                BCC.counter.all.green++
                BCC.counter.all.yellow++
                BCC.counter.now.noyellow = 0
                BCC.counter.now.red = 0
            }
            else{
                BCC.counter.now.green++
                BCC.counter.all.green++
                BCC.counter.now.noyellow++
                BCC.counter.now.red = 0
            }
        },
        Calculate: function(odds){
            BCC.SetOdds(odds)
            BCC.SetCounters()
            BCC.SetBetBase()
            var win = BCC.counter.now.win > 0
            var wintext = "Loss"
            if(win == true){
                wintext = "Win"
            }
            var types = ["Bet", "Payout"]
            if(BCC.placebet == false && BCC.counter.now.red == config.waitForRed.value){
                BCC.placebet = true
            }
            if(BCC.placebet == true && BCC.counter.now.loss == config.lossReset.value){
                BCC.placebet = false
            }
            if(BCC.placebet == true && BCC.counter.now.win == config.winRepeat.value){
                BCC.placebet = false
            }

            
            // config.baseBet.value = config.moonBet.value
            // config.baseBetPercent.value = config.moonBetPercent.value
            // config.moonBetSeq.value
            // config.moonPayout.value
            // config.moonPayoutSeq.value
            // config.moonPhase.value

            if(BCC.placebet == false){
                types.forEach((type, index, arr) => { 
                    BCC[type].current = BCC[type].base;
                })
                return;
            }
            // config.winRepeat.value
            // config.lossReset.value
            // config.waitForRed.value
            types.forEach((type, index, arr) => { 
                var switchValue = config[`on${type}${wintext}`].value
                switch(switchValue){
                    case 'none':{
                        BCC[type].current = BCC[type].base;
                        break;
                    }
                    case 'add':{
                        BCC[type].current += BCC[type][wintext]
                        break;
                    }
                    case 'sub':{
                        BCC[type].current -= BCC[type][wintext]
                        break;
                    }
                    case 'mul':{
                        BCC[type].current *= BCC[type][wintext]
                        break;
                    }
                    case 'div':{
                        BCC[type].current /= BCC[type][wintext]
                        break;
                    }
                    case 'seq':{
                        var seqIndex = BCC.counter.loss - 1
                        if(seqIndex > BCC[type][wintext].length - 1){
                            seqIndex = BCC[type][wintext].length - 1
                        }
                        if(seqIndex >= 0){
                            if(type == "Bet"){
                                BCC[type].current *= BCC[type][wintext][seqIndex]
                            }
                            else{
                                BCC[type].current = BCC[type][wintext][seqIndex]
                            }
                        }
                        break;
                    }
                }
                switch(switchValue){
                    case 'add':
                    case 'mul':
                    case 'seq':{
                        if (BCC[type].current > config[`max${type}`].value){
                            log.error(`Maximum ${type} reached!`);
                            BCC[type].current = config[`max${type}`].value
                            return maxPayout;
                        }
                        break;
                    }
                    case 'sub':
                    case 'div':{
                        if (BCC[type].current < config[`min${type}`].value){
                            log.error(`Minimum ${type} reached!`);
                            BCC[type].current = config[`min${type}`].value
                        }
                        break;
                    }
                }
                BCC[type].current = BCC[type].current.toFixed(BCC.NCS(type))
            });
        },
        LogObject: function(data){
            Object.keys(data).forEach((j, i) => { 
                log.success(`${j}: ${data[j]}`);
            });
            //log.success(Object.keys(data));
        }
    }
    BCC.InitVars()

    game.onBet = function () {
        if(BCC.dobet && BCC.placebet){
            game.bet(1, 1.01).then(function (payout){
                log.success(`Won: ${payout}`)
            })
        }
    }
    
    engine.on('GAME_ENDED', function (data){
        BCC.Calculate(data.odds)
    });
}