var config = {
    dobetlabel: {label: 'Live Mode', type: 'title'},
    dobet: {label: '', value: true, type: 'radio',
      options: [
        {value: true, label: 'Yes'},
        {value: false, label: 'No'}
      ]
    },

    baselabel: {label: '---- BASE ----', type: 'title'},
    baseBetPerCentlabel: {label: 'Starting Bet by Percent', type: 'title'},
    baseDoBetPercent: {label: '', value: true, type: 'radio',
      options: [
        {value: true, label: 'Yes'},
        {value: false, label: 'No'}
      ]
    },
    baseBet: {label: 'Starting Bet:', value: currency.minAmount, type: 'number'},
    baseBetPercent: {label: 'Starting Bet in Percent:', value: 0.1, type: 'number'},
    baseBetMultiP: {label: 'Bet Multiplier:', value: 2, type: 'number'},
    basePayout: {label: 'Starting Payout:', value: 3, type: 'number'},
    baseWait: {label: 'Wait for lower Odds:', value: 6, type: 'number'},
    baseLossReset: {label: 'Reset After Loss Streak of:', value: 11, type: 'number'},

    midlowlabel: {label: '---- MIDLOW ----', type: 'title'},
    midlowBetPerCentlabel: {label: 'Starting Bet by Percent', type: 'title'},
    midlowDoBetPercent: {label: '', value: true, type: 'radio',
      options: [
        {value: true, label: 'Yes'},
        {value: false, label: 'No'}
      ]
    },
    midlowBet: {label: 'Starting Bet:', value: currency.minAmount, type: 'number'},
    midlowBetPercent: {label: 'Starting Bet in Percent:', value: 0.1, type: 'number'},
    midlowBetMultiP: {label: 'Bet Multiplier:', value: 2, type: 'number'},
    midlowPayout: {label: 'Starting Payout:', value: 2, type: 'number'},
    midlowWait: {label: 'Wait for lower Odds:', value: 4, type: 'number'},
    midlowLossReset: {label: 'Reset After Loss Streak of:', value: 6, type: 'number'},

    midlabel: {label: '---- MID ----', type: 'title'},
    midBetPerCentlabel: {label: 'Starting Bet by Percent', type: 'title'},
    midDoBetPercent: {label: '', value: true, type: 'radio',
      options: [
        {value: true, label: 'Yes'},
        {value: false, label: 'No'}
      ]
    },
    midBet: {label: 'Starting Bet:', value: currency.minAmount, type: 'number'},
    midBetPercent: {label: 'Starting Bet in Percent:', value: 0.15, type: 'number'},
    midBetMultiP: {label: 'Bet Multiplier:', value: 1.25, type: 'number'},
    midPayout: {label: 'Starting Payout:', value: 5, type: 'number'},
    midWait: {label: 'Wait for lower Odds:', value: 8, type: 'number'},
    midLossReset: {label: 'Reset After Loss Streak of:', value: 15, type: 'number'},

    highlabel: {label: '---- HIGH ----', type: 'title'},
    highBetPerCentlabel: {label: 'Starting Bet by Percent', type: 'title'},
    highDoBetPercent: {label: '', value: true, type: 'radio',
      options: [
        {value: true, label: 'Yes'},
        {value: false, label: 'No'}
      ]
    },
    highBet: {label: 'Starting Bet:', value: currency.minAmount, type: 'number'},
    highBetPercent: {label: 'Starting Bet in Percent:', value: 0.185, type: 'number'},
    highBetMultiP: {label: 'Bet Multiplier:', value: 1.1, type: 'number'},
    highPayout: {label: 'Starting Payout:', value: 10, type: 'number'},
    highWait: {label: 'Wait for lower Odds:', value: 60, type: 'number'},
    highLossReset: {label: 'Reset After Loss Streak of:', value: 30, type: 'number'},
    
    lowlabel: {label: '---- LOW ----', type: 'title'},
    lowBetPerCentlabel: {label: 'Starting Bet by Percent', type: 'title'},
    lowDoBetPercent: {label: '', value: true, type: 'radio',
      options: [
        {value: true, label: 'Yes'},
        {value: false, label: 'No'}
      ]
    },
    lowBet: {label: 'Starting Bet:', value: currency.minAmount, type: 'number'},
    lowBetPercent: {label: 'Starting Bet in Percent:', value: 0.125, type: 'number'},
    lowBetMultiP: {label: 'Bet Multiplier:', value: 3, type: 'number'},
    lowPayout: {label: 'Starting Payout:', value: 1.5, type: 'number'},
    lowWait: {label: 'Wait for lower Odds:', value: 4, type: 'number'},
    lowLossReset: {label: 'Reset After Loss Streak of:', value: 3, type: 'number'}
}

function main(){
    var BCC = { 
        mode: "base",
        CfgVal: function(key, mode){
            if(undefined == mode){
                mode = BCC.mode
            }
            return config[`${mode}${key}`].value
        },
        modeDef: ["mid", "base", "low", "high"],
        keyDef: ["DoBetPercent", "Bet", "BetPercent", "BetMultiP",
                  "Payout", "Wait", "LossReset"],
        types: ["Bet", "Payout"],
        currencyNCS: {
            JB: 4,
            BCD: 6
        },
        dobet: config.dobet.value,
        placebet: false,
        wallet: currency.amount,
        Odds: {
            all: [],
            current: 1.0
        },
        Counter: {
            win: 0,
            loss: 0,
            base: 0,
            low: 0,
            high: 0,
            mid: 0,
            midlow: 0
        },
        Bet: {},
        Payout: {},
        GetMaxBase: function(mode){
            var amount = currency.maxAmount
            for(var i=BCC.CfgVal("LossReset", mode) - 1; i > 0; i--){
                amount /= BCC.CfgVal("BetMultiP", mode)
            }
            return parseFloat(amount.toFixed(BCC.NCS("Bet")))
        },
        SetBetBase: function(){
            BCC.modeDef.forEach((mode, index, arr) => { 
                if(BCC.CfgVal("DoBetPercent", mode)){
                    BCC.Bet[mode] = parseFloat(parseFloat((BCC.wallet / 100 * BCC.CfgVal("BetPercent", mode)).toFixed(BCC.NCS("Bet"))))
                    if(BCC.Bet[mode] > BCC.GetMaxBase(mode)){
                        BCC.Bet[mode] = BCC.GetMaxBase(mode)
                    }
                }
            })
        },
        InitVars: function(){
            BCC.wallet = parseFloat(BCC.wallet.toFixed(BCC.NCS("Bet")))
            BCC.Bet = {
                base: BCC.CfgVal("Bet", "base"), 
                low: BCC.CfgVal("Bet", "low"), 
                high: BCC.CfgVal("Bet", "high"), 
                mid: BCC.CfgVal("Bet", "mid"), 
                midlow: BCC.CfgVal("Bet", "midlow"), 
                current: BCC.CfgVal("Bet", "base")
            }
            BCC.Payout = {
                base: BCC.CfgVal("Payout", "base"), 
                low: BCC.CfgVal("Payout", "low"), 
                high: BCC.CfgVal("Payout", "high"), 
                mid: BCC.CfgVal("Payout", "mid"), 
                midlow: BCC.CfgVal("Payout", "midlow"), 
                current: BCC.CfgVal("Payout", "base")
            }
            BCC.SetBetBase()
            BCC.ResetCurrent()
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
            log.info(`Odds: ${odds}`)
            console.log(`${BCC.Odds.all.length}: ${odds}`)
        },
        SetCounters: function(){
            if(BCC.placebet){
                if(BCC.Odds.current >= BCC.Payout.current){
                    BCC.Counter.win++
                    BCC.Counter.loss = 0
                    var marge = parseFloat(parseFloat((parseFloat(BCC.Bet.current) * (parseFloat(BCC.Payout.current) - 1)).toFixed(BCC.NCS("Bet"))))
                    BCC.wallet += marge
                    log.success(`WIN: ${marge}`)
                }
                else{
                    BCC.Counter.loss++
                    BCC.Counter.win = 0
                    var marge = parseFloat(parseFloat(BCC.Bet.current).toFixed(BCC.NCS("Bet")))
                    BCC.wallet -= marge
                    log.error(`LOST: ${marge} (${BCC.Counter.loss}/${BCC.CfgVal("LossReset")})`)
                }
                BCC.wallet = parseFloat(BCC.wallet.toFixed(BCC.NCS("Bet")))
                log.info("-------------")
            }
            else{
                BCC.Counter.loss = 0
                BCC.Counter.win = 0
            }
            BCC.modeDef.forEach((mode, index, arr) => { 
                if(BCC.Odds.current < BCC.CfgVal("Payout", mode)){
                    BCC.Counter[mode]++
                }
                else{
                    BCC.Counter[mode] = 0
                }
            })
        },
        ResetCurrent: function(){
            BCC.types.forEach((type, index, arr) => { 
                BCC[type].current = BCC[type][BCC.mode];
            })
        },
        ChangeMode: function(mode){
            BCC.types.forEach((type, index, arr) => { 
                BCC[type].current = BCC[type][mode];
            })
            BCC.mode = mode
        },
        SetPlaceBet: function(){
            BCC.modeDef.forEach((mode, index, arr) => { 
                if(BCC.placebet == false && (BCC.CfgVal("Wait", mode) <= BCC.Counter[mode])){            
                    BCC.placebet = true
                    BCC.ChangeMode(mode)
                }
            })
            if(BCC.placebet == true && BCC.Counter.loss == BCC.CfgVal("LossReset")){
                BCC.placebet = false
            }
            if(BCC.placebet == true && BCC.Counter.win >= 1){
                BCC.placebet = false
            }
        },
        AddToBet: function(){
            if(BCC.Counter.loss > 0){
                BCC.Bet.current *= BCC.CfgVal("BetMultiP")
                if (BCC.Bet.current > currency.maxAmount){
                    log.error(`Maximum Bet reached!`);
                    BCC.Bet.current = currency.maxAmount
                }
                if(BCC.Bet.current > BCC.wallet){
                    BCC.Bet.current = BCC.wallet
                }
                BCC.Bet.current = parseFloat((parseFloat(BCC.Bet.current)).toFixed(BCC.NCS("Bet")))
            }
        },
        Calculate: function(odds){
            BCC.SetOdds(odds)
            BCC.SetCounters()
            BCC.SetBetBase()
            BCC.SetPlaceBet()
            
            if(BCC.placebet == false){
                BCC.ResetCurrent()
                return
            }
            BCC.AddToBet()
            log.info(`Place Bet: ${BCC.Bet.current} Payout: ${BCC.Payout.current}`)
        }
    }
    BCC.InitVars()
    game.onBet = function () {
        if(BCC.dobet && BCC.placebet){
         game.bet(BCC.Bet.current, BCC.Payout.current).then(function (payout){
             //log.success(`Won: ${payout}`)
            })
        }
    }
    
    engine.on('GAME_ENDED', function (data){
        BCC.Calculate(data.odds)
    });
}