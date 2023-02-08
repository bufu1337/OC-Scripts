var currency = {
    minAmount: 1,
    maxAmount: 2000,
    amount: 10000,
    currencyName: "JB"
}
// currency = {
//     minAmount: 0.000001,
//     maxAmount: 20000,
//     amount: 0.04,
//     currencyName: "BCD"
// }
var log = {
    success: function(text){
        console.log(text)
    },
    error: function(text){
        console.log(text)
    },
    info: function(text){
        console.log(text)
    }
}
var config = {
    dobetlabel: {label: 'Live Mode', type: 'title'},
    dobet: {label: '', value: true, type: 'radio',
      options: [
        {value: true, label: 'Yes'},
        {value: false, label: 'No'}
      ]
    },
    betPerCentlabel: {label: 'Starting Bet by Percent', type: 'title'},
    dobetPerCent: {label: '', value: true, type: 'radio',
      options: [
        {value: true, label: 'Yes'},
        {value: false, label: 'No'}
      ]
    },
    baseBet: {label: 'Starting Bet:', value: currency.minAmount, type: 'number'},
    baseBetPercent: {label: 'Starting Bet in Percent:', value: 0.1, type: 'number'},
    maxBet: {label: 'Maximum Bet:', value: currency.maxAmount, type: 'number'},
    minBet: {label: 'Minimum Bet:', value: currency.minAmount, type: 'number'},

    basePayout: {label: 'Starting Payout:', value: 1.5, type: 'number'},
    maxPayout: {label: 'Maximum Payout:', value: 20.00, type: 'number'},
    minPayout: {label: 'Minimum Payout:', value: 1.01, type: 'number'},

    winRepeat: {label: 'Reset After Win Streak of:', value: 2000, type: 'number'},
    LossReset: {label: 'Reset After Loss Streak of:', value: 4, type: 'number'},
    waitForRed: {label: 'Wait for Red:', value: 0, type: 'number'},

    moonSettingsTitle :{label: 'Moon Settings', type: 'title'},
    moonBet: {label: 'Bet when awaiting moon:', value: currency.minAmount, type: 'number'},
    moonBetPercent: {label: 'Starting Bet in Percent:', value: 1, type: 'number'},
    moonBetSeq: {label: 'Bet Sequense Multiplier when awaiting moon:', value: "1.1,1.1,1.1,1.1,1.1,1.2,1.2,1.2,1.2,1.2,1.3", type: 'text'},
    moonPayout: {label: 'Payout when awaiting moon:', value: 10, type: 'number'},
    moonPayoutSeq: {label: 'Payout Sequense when awaiting moon:', value: "10", type: 'text'},
    moonPhase: {label: 'Moon Phase after X Games:', value: 50, type: 'number'},
    moonLossReset: {label: 'Reset moon after Loss Streak of:', value: 20, type: 'number'},

    onBetLossTitle: {label: 'Loss Bet Settings', type: 'title'},
    onBetLoss: {label: '', value: 'seq', type: 'radio',
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
    seqBetLoss: { label: 'Sequense Bet Multiplier', value: "6,4.5,3", type: 'text'},

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
    addPayoutLoss: { label: 'Increase Payout By:', value: 1, type: 'number' },
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

//function main(){
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
            temp: [1.1, 2.44, 7.45, 1.56, 1.55, 3.74, 6.42, 7.49, 1.9, 3.18, 1.76, 2.07, 2.41, 1.55, 1.92, 11.81, 13.71, 1.05, 1.27, 1.77, 2.82, 2.78, 1.86, 1.24, 1.58, 1.97, 1.99, 7.9, 1.1, 114.21, 7.16, 1.24, 1.31, 9.04, 3.24, 1.4, 5.56, 3.78, 1, 1.66, 1.41, 1.03, 3.57, 2.08, 7.53, 1.18, 1.01, 1.17, 2.33, 1.78, 1.69, 2.58, 28.12, 2.81, 1.16, 12.11, 6.55, 1.91, 1.36, 1.12, 17.34, 2.19, 1.7, 2.47, 2.96, 22.79, 7.98, 11.34, 1.02, 1, 1.09, 1.83, 2.25, 17.58, 1.28, 43.55, 1.22, 1.42, 1.4, 1.63, 2.58, 1.32, 31.36, 1.8, 1.07, 3.02, 2.23, 9.39, 1.54, 1.24, 3.13, 4.1, 1.12, 1.06, 1.56, 1.85, 1.16, 1.92, 1.26, 8.45, 82.88, 2.41, 3.15, 1.87, 2.18, 5.05, 1.77, 2.71, 1.19, 1.45, 1.38, 1.13, 9.99, 1.08, 1.82, 13.34, 1.99, 1.69, 16.97, 1, 2.36, 1.87, 1.39, 1.07, 2.2, 1.26, 1.19, 2.32, 4.15, 13.18, 1.43, 1.05, 1.4, 3.8, 1.03, 3.75, 13.5, 7.7, 1.93, 2.11, 4.05, 1.07, 2.3, 1.01, 1.14, 1.95, 1.27, 4.96, 2.56, 1.72, 6.61, 2.19, 1.56, 1.59, 11.01, 1.48, 1.02, 1.11, 1, 1.25, 2.01, 1.43, 2.53, 1.06, 1.13, 1.23, 1.97, 6.43, 1.14, 2.58, 3.11, 2.16, 1.25, 9.93, 2.43, 6.91, 11.53, 3.78, 1.27, 4.12, 8.34, 8.8, 1.37, 2.62, 1.13, 5.34, 1.47, 1.18, 2.87, 2.23, 1.43, 2044.07, 1.4, 1.06, 3.18, 1.35, 1.51, 1.36, 7.22, 1.07, 1.01, 1.15, 1.2, 7.19, 11.05, 3.92, 1.06, 1.01, 1.11, 1.52, 1.08, 1.52, 1.38, 2.35, 1.42, 1.54, 4.43, 33.38, 12.1, 3.29, 1.42, 1, 12.74, 12.87, 3.18, 35.19, 4.46, 1.52, 4.97, 1.37, 1.49, 1.78, 18.41, 1.18, 2.81, 2.88, 1, 2.32, 55.18, 2.25, 1.31, 1.34, 1.96, 5.48, 1.03, 1.05, 1.82, 1.13, 1, 4.52, 5.46, 1.23, 3.8, 1.17, 22.77, 1.25, 1.34, 2.73, 1.64, 1.53, 1.95, 2.19, 169.52, 1.6, 3.65, 365.46, 2.18, 2.19, 3.63, 1.18, 1.4, 14.49, 2.25, 1.05, 1.16, 1, 99.04, 41.59, 163.48, 1.31, 1.85, 10.14, 8.97, 2.8, 2.9, 2.17, 1.15, 1.54, 1.42, 1.01, 1.16, 1.22, 1.42, 3.41, 1.92, 1.14, 1.05, 1, 2.8, 2.5, 1.46, 4.85, 1.83, 5.21, 1.79, 2.77, 1.61, 1.03, 1.14, 1.13, 4.46, 2.9, 5.88, 4.37, 2.2, 6.4, 1.05, 7.28, 1.96, 3.79, 1.35, 1.22, 1.05, 1.43, 1.31, 8.22, 1.06, 1.13, 1.22, 1, 8.78, 2.14, 8.03, 1.49, 4.75, 9.82, 1.12, 1.21, 3.36, 64, 3.17, 1, 7.46, 1.18, 6.49, 1.75, 2.27, 1.34, 102.6, 1.36, 1, 1.78, 1.21, 3.31, 3.4, 1.2, 1.26, 2.49, 1.48, 4.93, 6.88, 2.36, 1.02, 4.13, 1.32, 1.1, 1.98, 1.66, 1.95, 2.15, 3.74, 1.32, 1.14, 5.19, 1.6, 1.19, 2.4, 1.96, 1.1, 2.62, 2.84, 4.76, 1.66, 1.01, 240.45, 8.96, 2.62, 1.12, 4.5, 2.94, 8.58, 8.45, 9.48, 1.18, 2.55, 2.97, 14.21, 2.88, 3.63, 2.62, 1.26, 2.02, 16.49, 1.61, 1.2, 1.1, 35.84, 1.18, 4.25, 1.77, 1.32, 6.99, 1.69, 2.81, 1.63, 1.03, 1.38, 3.81, 2.09, 1, 1.21, 2.41, 2.75, 3.12, 1.08, 1.27, 32.39, 1.27, 1.23, 1.39, 1.71, 1.28, 1.65, 6.05, 13.54, 114.63, 5.03, 4.79, 1.43, 1.05, 2.58, 1.39, 3.36, 4.42, 1.02, 2.29, 1.73, 1.1, 2.27, 25.83, 2.05, 510.43, 1.02, 16.76, 1.23, 19.72, 1.42, 1.09, 2.08, 2.68, 1.43, 1.27, 104.17, 1.04, 1.88, 7.13, 1.41, 1.25, 1.27, 1.26, 1.18, 1.87, 2, 1.23, 1.45, 1.06, 2.11, 4.39, 1.75, 6.26, 2.26, 13.73, 1.48, 1.25, 1.14, 3.12, 2.99, 2.16, 1.27, 1.34, 1.14, 1.37, 1.56, 4.42, 1.61, 1.21, 8.33, 1.96, 1, 1.55, 1.29, 1.14, 2.43, 8.63, 2.58, 3.09, 2.66, 18.29, 22.8, 12.86, 1.89, 275.99, 3.19, 3.12, 2.23, 1, 1.72, 1.1, 1.74, 1.17, 1.32, 1.6, 1.69, 1.14, 2.42, 13.04, 63.9, 1.41, 2.21, 1.65, 1.42, 1.24, 2.17, 1.01, 1.57, 5.01, 24.7, 1.23, 5.75, 1.39, 2.34, 10.82, 1.66, 12.68, 6.9, 5.37, 5.53, 1.47, 1.37, 2.48, 2.85, 5.45, 4.62, 1.53, 1.07, 1.36, 1.27, 1.14, 4.29, 29.2, 2.65, 1.11, 1.37, 1.45, 1, 1.79, 1.47, 1.2, 1, 2.26, 9.27, 1.31, 2.2, 1.03, 7.11, 1.27, 1.72, 6.67, 9.34, 2.98, 1.56, 1.09, 1.78, 13.06, 1.01, 1.47, 1.1, 1.43, 37.39, 14.75, 1.22, 2.52, 10.78, 5.75, 1.26, 1.45, 1.62, 9.56, 1.3, 1.98, 2.23, 223.25, 3.43, 2.7, 1.11, 1.01, 5.31, 6.64, 1.09, 24.6, 1.23, 1.95, 1.8, 1.73, 1.22, 1.06, 1.07, 1.11, 1.2, 1.4, 1.67, 1.25, 1.1, 13.87, 3.28, 1, 1.56, 1.34, 1.97, 1.03, 1.47, 2.11, 4.04, 19.27, 1.2, 13.31, 1.24, 3.17, 1.54, 1.15, 1.41, 1.95, 1.31, 15.57, 2.55, 1.45, 6.64, 1.97, 5.95, 1.16, 1.22, 1.41, 1.28, 2.72, 1.08, 1.06, 1.66, 4.17, 9.13, 1.53, 1.72, 6.78, 7.61, 1.04, 1.38, 2.78, 4.18, 1, 1.29, 3.22, 169.17, 1.84, 1.1, 1.45, 2.08, 2.95, 1.04, 3, 1.99, 3.68, 1.16, 1.85, 1.44, 1.92, 46.96, 3.33, 4.59, 15.94, 1.42, 1.03, 2.13, 1.78, 1.34, 2.1, 1.37, 31.19, 1.55, 1.3, 10.05, 1.92, 1.32, 3.49, 2.53, 1.41, 4.01, 1.02, 31.73, 3.41, 5.26, 1.65, 141.34, 1.9, 1.91, 1.07, 2.15, 3.15, 1.88, 52.83, 1, 1.43, 2.27, 1.64, 3.21, 36.07, 1.88, 2.74, 20.47, 1.12, 2.85, 1.22, 1.78, 4.5, 1.4, 1.17, 11.69, 3.62, 6.51, 1.43, 1.06, 2.85, 2.26, 72.14, 2.35, 2.64, 1.77, 6.13, 2.09, 1.28, 1.44, 1.7, 4.04, 2.39, 15.23, 1.6, 1.17, 2.62, 1.09, 2.7, 2.51, 3.48, 2.54, 9, 66.88, 2.28, 1.05, 1.6, 7.03, 1.29, 1.19, 1.15, 1.61, 5.28, 1.32, 9.22, 21.37, 14.05, 1.55, 1.22, 1.41, 2.35, 1.31, 6.36, 1.09, 1.2, 3.04, 1.16, 1.21, 1.55, 1.58, 1.96, 3.9, 1.22, 1.29, 2.58, 2.34, 17.59, 1.22, 4.54, 1.61, 1.2, 2.36, 9.69, 1.11, 2.58, 1.14, 12.92, 2.44, 1.88, 6.22, 2.45, 2.84, 3.71, 2.68, 1.2, 17.9, 2.41, 47, 1.52, 2.32, 4.54, 1.37, 1.85, 1.19, 3.88, 1.32, 2.89, 2.14, 7.92, 1.31, 1.36, 1.22, 1.94, 1.16, 2.77, 7.5, 7, 1.04, 1.18, 2.83, 3.82, 8.1, 1.66, 1.36, 1.28, 1.74, 1.17, 1.57, 1.38, 1.5, 1.92, 3.23, 6.89, 2.15, 1.77, 9.68, 1.29, 6.62, 3.3, 5.73, 2.75, 3.07, 1.15, 2.69, 9.72, 1.16, 36.54, 2.13, 30.53, 5.82, 1.44, 1.46, 1.12, 4.69, 3.44, 259.12, 3.72, 7.28, 2.19, 1.72, 1.37, 1.5, 5.22, 5.49, 8.23, 3.5, 3.09, 1.53, 17.94, 4.88, 4.95, 2.16, 1.35, 4.45, 2.11, 1.51, 3.02, 1.09, 5.64, 3.52, 3.08, 4.52, 2.81, 3.5, 1.25, 29.97, 3.13, 6.2, 1.7, 2.68, 2.1, 13.45, 1.15, 1.55, 6.71, 11.2, 1.36, 1.3, 6.76, 2.92, 2.09, 1.41, 3.68, 1.02, 1.04, 9.28, 3.89, 3.76, 1.35, 9.88, 3.76, 1.37, 34.16, 1.05, 2.51, 1.09, 1.17, 1.53, 1.33, 3.36, 1.46, 2.75, 1.16, 1.16, 2.6, 1.48, 1.46, 1.03, 6.12, 3.01, 16.1, 7.09, 7.21, 1.18, 1.45, 2.8, 18.62, 1.22, 1.03, 1.92, 2.08, 3.7, 3.07, 1.24, 2.01, 4.64, 1.03, 1.22, 1.01, 1.05, 2.85, 1.22, 2.51, 1.32, 7.93, 1.44, 9.67, 10.46, 1.34, 2.09, 2.05, 2.63, 1.44, 1.81, 5.55, 1.50, 3.05, 1.03, 19.98, 6.26, 1.19, 1.02, 1.26, 4.56, 1.41, 3.10, 2.53, 1.04, 11.16, 5.98, 1.24, 4.22, 1.04, 4.13, 19.69, 1.08, 1.77, 3.78, 1.41, 21.78, 1.14, 1.34, 1.09, 71.66, 8.71, 1.37, 1.93, 14.22, 4.65, 1.06, 1.36, 1.43, 1.64, 1.61, 84.27, 1.61, 5.83, 6.74, 1.04, 1.17, 1.35, 1.86, 1.00, 1.43, 1.01, 2.63, 6.93, 1.80, 1.05, 1.57, 1.26, 2.18, 3.89, 2.03, 1.28, 1.17, 4.82, 1.38, 12.36, 1.23, 5.73, 1.36, 1.83, 6.65, 4.98, 2.10, 3.84, 2.53, 1.67, 19.28, 5.38, 3.21, 18.51, 1.89, 6.59, 3.07, 4.32, 1.70, 1.48, 2.93, 15.40, 2.86, 21.91, 3.47, 3.12, 1.83, 1.53, 1.19, 3.87, 1.22, 4.21, 2.10, 1.19, 1.60, 1.13, 29.84, 3.61, 2.45, 6.75, 1.03, 1.19, 1.92, 1.42, 1.41, 7.37, 2.40, 2.04, 1.13, 2.95, 1.26, 2.12, 4.02, 1.77, 1.33, 1.13, 2.17, 1.50, 8.65, 1.78, 10.34, 1.48, 1.84, 1.27, 1.57, 1.87, 3.87, 1.13, 1.02, 3.27, 2.58, 1.84, 2.96, 1.03, 1.87, 1.04, 6.73, 1.09, 2.10, 5.32, 4.28, 2.53, 1.03, 1.86, 10.26, 1.16, 1.52, 4.15, 1.25, 12.98, 14.33, 1.45, 2.08, 1.12, 1.28, 1.14, 1.15, 5.18, 16.72, 1.03, 6.54, 1.86, 2.17, 1.26, 7.57, 1.43, 2.04, 1.32, 3.94, 2.00, 1.49, 4.18, 2.24, 1.81, 1.28, 31.35, 2.80, 1.13, 1.17, 47.22, 1.77, 1.18, 6.09, 12.41, 1.76, 1.35, 39.99, 2.23, 1.21, 5.18, 2.07, 6.90, 5.60, 1.04, 137.47, 2.37, 1.37, 1.13, 3.04, 2.73, 1.19, 1.51, 2.16, 2.62, 1.58, 1.21, 5.69, 1.69, 12.22, 1.64, 1.81, 4.68, 1.54, 1.12, 1.56, 1.29, 1.05, 2.32, 3.94, 23.92, 13.55, 1.15, 1.02, 11.88, 2.26, 1.08, 3.85, 4.64, 1.04, 2.19, 13.94, 1.20, 3.16, 1.93, 1.33, 2.23, 1.13, 4.58, 1.37, 4.49, 2.51, 1.11, 4.42, 1.43, 1.55, 2.04, 1.00, 1.70, 60.25, 1.82, 2.64, 1.72, 1.17, 2.85, 3.04, 1.06, 1.74, 2.46, 1.07, 2.83, 1.18, 1.09, 2.94, 1.15, 9.30, 1.03, 1.43, 4.47, 1.01, 1.55, 1.46, 2.99, 7.61, 2.20, 2.58, 8.22, 1.62, 1.54, 1.02, 4.82, 1.03, 2.33, 21.54, 1.06, 33.08, 1.10, 1.78, 1.10, 8.59, 7.02, 2.76, 12.27, 2.12, 2.78, 1.29, 1.13, 3.59, 1.14, 1.91, 1.38, 1.65, 2.11, 1.13, 4.20, 1.51, 8.70, 9.13, 10.27, 4.37, 60.40, 5.01, 1.27, 8.60, 2.77, 8.84, 1.28, 7.25, 19.18, 1.64, 1.35, 4.68, 4.47, 1.66, 17.32, 1.57, 4.34, 1.56, 2.89, 10.67, 1.28, 1.77, 1.81, 2.20, 7.90, 2.00, 2.82, 2.27, 15.40, 1.53, 7.96, 1.16, 1.71, 14.83, 2.12, 1.00, 62.98, 1.20, 1.78, 7.37, 2.56, 9.83, 2.30, 2.82, 1.47, 3.12, 2.40, 1.01, 1.27, 1.00, 2.46, 122.43, 1.40, 1.02, 2.28, 1.34, 1.05, 1.16, 3.41, 2.72, 1.75, 10.62, 3.07, 1.16, 1.14, 2.79, 2.51, 1.47, 2.58, 10.98, 3.88, 1.81, 9.80, 2.41, 1.11, 19.55, 3.14, 1.04, 1.43, 1.76, 1.26, 22.07, 6.65, 1.29, 1.52, 2.21, 7.86, 5.41, 4.14, 1.05, 10.25, 1.37, 1.20, 1.97, 3.22, 10.71, 3.95, 2.35, 11.84, 2.58, 30.62, 2.85, 1.96, 1.44, 1.24, 1.93, 3.47, 4.92, 5.89, 1.36, 59.17, 2.33, 3.03, 3.22, 1.92, 2.82, 2.05, 3.36, 2.71, 35.85, 1.05, 12.49, 1.32, 6.36, 1.78, 10.04, 1.80, 2.26, 6.55, 1.00, 12.31, 1.83, 2.93, 6.48, 1.99, 2.38, 1.38, 2.26, 8.48, 3.29, 10.11, 4.83, 1.32, 1.18, 1.38, 2.97, 1.00, 1.62, 1.10, 1.23, 6.00, 5.10, 1.13, 1.16, 1.94, 1.02, 3.59, 1.00, 1.28, 1.22, 1.18, 1.08, 4.28, 1.00, 1.37, 1.53, 1.24, 1.71, 3.65, 3.92, 1.05, 1.29, 4.42, 3.69, 2.91, 1.79, 1.59, 1.51, 12.02, 2.45, 2.97, 1.35, 1.62, 1.22, 8.35, 1.29, 1.64, 1.4, 2.03, 1.05, 3.96, 41.49, 8.04, 4.71, 2.07, 19.65, 13.17, 1.53, 1.86, 1.22, 1.91, 3.88, 1.11, 1.27, 1.24, 3.03, 4.74, 1.51, 3.24, 2.14, 4.64, 1.57, 1.28, 25.47, 3.77, 2.26, 3.23, 2.93, 1.19, 3.25, 1.75, 1.34, 2.99, 1, 1.44, 191.09, 1.52, 1.27, 5.76, 1.09, 1.32, 1.63, 1.33, 1.93, 13.29, 13.53, 1.45, 1.57, 2.29, 1.82, 1.42, 1.1, 1.26, 2.97, 19.25, 3.08, 3.6, 5.57, 30.92, 1.92, 2.64, 1.87, 1.18, 1.62, 29.11, 1.79, 4.12, 1.91, 1.84, 6.92, 1.31, 4.04, 2.38, 4.37, 22.27, 3.26, 2.37, 1.77, 1.71, 2.26, 4.75, 1.45, 2.86, 4.27, 1.19, 4.18, 2.09, 26.23, 5.08, 1.34, 1.52, 24.08, 2.11, 1.37, 1.55, 1.05, 1.2, 3.55, 1.03, 2.24, 2.28, 10.59, 3.11, 1.13, 1.63, 1.69, 2.27, 2.2, 2.6, 1.08, 6, 2.5, 1.9, 2.14, 2.97, 4.73, 17.9, 1.51, 1.26, 2.37, 2.79, 1.51, 1.32, 2.6, 6.78, 2.11, 1.04, 2.51, 1.34, 7.29, 2.46, 1.95, 3.48, 1.56, 1, 1, 1.08, 84.43, 4.64, 87.67, 1.45, 3.48, 1.64, 2.09, 3.13, 2.54, 3.16, 1.35, 1.19, 1.77, 1.53, 1.3, 1, 1.09, 1.09, 6.04, 1.51, 3.4, 2.27, 8.25, 1.08, 4.2, 1.39, 1, 1.6, 3.84, 7.87, 1.51, 3.49, 5.28, 1.6, 1.31, 1.08, 1, 1.85, 1.66, 2.41, 11.05, 1.6, 27.3, 1.04, 1.76, 2.8, 3.74, 2.31, 1.53, 26.8, 1.23, 138.83, 17.59, 1.71, 1.74, 1, 2.51, 1.21, 1.91, 1.97, 3.5, 1.14, 1.98, 1.65, 59.68, 3.58, 1.01, 3.27, 1.32, 1, 5.28, 4.29, 1.35, 1.52, 2.48, 2.47, 2.23, 4.91, 1.83, 2.47, 6.25, 3.19, 1.33, 2.89, 10.49, 2.18, 8.07, 7.13, 1.19, 1.12, 1.35, 9.3, 1.86, 5.75, 5.54, 2.29, 1], 
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
        moonBetting: false,
        Bet: {
            base: config.baseBet.value, 
            current: config.baseBet.value,
            Win: 0,
            Loss: 0,
            moonBase: config.moonBet.value,
            moonLoss: config.moonBetSeq.value
        },
        Payout: {
            base: config.basePayout.value, 
            current: config.basePayout.value,
            Win: 0,
            Loss: 0,
            moonBase: config.moonPayout.value,
            moonLoss: config.moonPayoutSeq.value
        },
        types: ["Bet", "Payout"],
        GetObjectAsString: function(data){
            var returning = ""
            Object.keys(data).forEach((j, i) => {
                var a = ""
                if(typeof(data[j]) == "object"){
                    a = `{${BCC.GetObjectAsString(data[j])}}`
                }
                else{
                    a = `${data[j]}`
                }
                var b = `${j}: ${a}`
                if(returning == ""){
                    returning = b
                }
                else{
                    returning += `, ${b}`
                }
            });
            return returning
        },
        GetMaxBase: function(moon){
            var wintext = "Loss"
            if(moon){
                wintext = "moonLoss"
            }
            var type = "Bet"
            var switchValue = "none"
            var amount = currency.maxAmount
            if(wintext == "moonLoss"){
                switchValue = "seq"
            }
            else{
                switchValue = config[`on${type}${wintext}`].value
            }
            for(var i=config[`${wintext}Reset`].value - 1; i > 0; i--){
                switch(switchValue){
                    case 'add':{
                        amount -= BCC[type][wintext]
                        break;
                    }
                    case 'mul':{
                        amount /= BCC[type][wintext]
                        break;
                    }
                    case 'seq':{
                        var seqIndex = i - 1
                        if(seqIndex > BCC[type][wintext].length - 1){
                            seqIndex = BCC[type][wintext].length - 1
                        }
                        if(seqIndex >= 0){
                            amount /= BCC[type][wintext][seqIndex]
                        }
                        break;
                    }
                }
            }
            return amount.toFixed(BCC.NCS("Bet"))
        },
        SetBetBase: function(){
            if(config.dobetPerCent.value){
                BCC.Bet.base = parseFloat((BCC.wallet / 100 * config.baseBetPercent.value).toFixed(BCC.NCS("Bet")-1))
                if(BCC.Bet.base > BCC.GetMaxBase(false)){
                    BCC.Bet.base = BCC.GetMaxBase(false)
                }
                BCC.Bet.moonBase = parseFloat((BCC.wallet / 100 * config.moonBetPercent.value).toFixed(BCC.NCS("Bet")-1))
                if(BCC.Bet.moonBase > BCC.GetMaxBase(true)){
                    BCC.Bet.moonBase = BCC.GetMaxBase(true)
                }
            }
        },
        InitVars: function(){
            BCC.types.forEach((type, tindex) => {
                ["Win","Loss"].forEach((s, index) => {
                    var test = config[`on${type}${s}`].value
                    if(test != "none"){
                        BCC[type][s] = config[(`${test}${type}${s}`)].value
                    }
                });
            });
            ["","moon"].forEach((moon, mindex) => {
                BCC.types.forEach((type, tindex) => {
                    if(config[`on${type}Loss`].value == "seq" || moon != ""){
                        BCC[type][`${moon}Loss`] = BCC[type][`${moon}Loss`].split(BCC.GetSeqSepartor(BCC[type][`${moon}Loss`]));
                        BCC[type][`${moon}Loss`].forEach((str, index) => { 
                            BCC[type][`${moon}Loss`][index] = parseFloat(str)
                        });
                    }
                });
            });
            BCC.wallet = parseFloat(BCC.wallet.toFixed(BCC.NCS("Bet")))
            BCC.SetBetBase()
            BCC.ResetCurrent()
        },
        GetSeqSepartor: function(seq){
            var separators = ['-', '/', ',', ' ']
            var returning = " "
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
            log.info(`Odds: ${odds}`)
            console.log(`${BCC.Odds.all.length}: ${odds}`)
        },
        SetCounters: function(){
            if(BCC.placebet){
                if(BCC.Odds.current >= BCC.Payout.current){
                    BCC.counter.now.win++
                    BCC.counter.all.win++
                    BCC.counter.now.loss = 0
                    var marge = parseFloat((parseFloat(BCC.Bet.current) * (parseFloat(BCC.Payout.current) - 1)).toFixed(BCC.NCS("Bet")))
                    BCC.wallet += marge
                    log.success(`WIN: ${marge}`)
                }
                else{
                    BCC.counter.now.loss++
                    BCC.counter.all.loss++
                    BCC.counter.now.win = 0
                    var marge = parseFloat(parseFloat(BCC.Bet.current).toFixed(BCC.NCS("Bet")))
                    BCC.wallet -= marge
                    log.error(`LOST: ${marge} (${BCC.counter.now.loss}/${config.LossReset.value})`)
                }
                BCC.wallet = parseFloat(BCC.wallet.toFixed(BCC.NCS("Bet")))
                log.info("-------------")
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
        ResetCurrent: function(){
            BCC.types.forEach((type, index, arr) => { 
                BCC[type].current = BCC[type].base;
            })
        },
        Calculate: function(odds){
            BCC.SetOdds(odds)
            BCC.SetCounters()
            var wintext = ""
            if(BCC.moonBetting == false){
                if(BCC.placebet == false && BCC.counter.now.red == config.waitForRed.value){
                    BCC.placebet = true
                }
                if(BCC.placebet == true && BCC.counter.now.loss == config.LossReset.value){
                    BCC.placebet = false
                }
                if(BCC.placebet == true && BCC.counter.now.win == config.winRepeat.value){
                    BCC.placebet = false
                }
                if(BCC.placebet == false && config.moonPhase.value <= BCC.counter.now.noyellow){            
                    BCC.placebet = true
                    BCC.moonBetting = true
                    BCC.types.forEach((type, index, arr) => { 
                        BCC[type].current = BCC[type].moonBase;
                    })
                }
            }
            else{
                if(BCC.counter.now.win > 0){
                    BCC.placebet = false
                    BCC.moonBetting = false
                }
                if(BCC.counter.now.loss == config.moonLossReset.value){
                    BCC.placebet = false
                    BCC.moonBetting = false
                }
            }
            
            BCC.SetBetBase()
            if(BCC.placebet == false){
                BCC.ResetCurrent()
                return;
            }

            if(BCC.counter.now.win > 0){
                wintext = "Win"
            }
            else if(BCC.counter.now.loss > 0){
                wintext = "Loss"
            }
            
            if(wintext != ""){
                BCC.types.forEach((type, index, arr) => {
                    var switchValue = "none"
                    if(BCC.moonBetting){
                        wintext = "moonLoss";
                        switchValue = "seq"
                    }
                    else{
                        switchValue = config[`on${type}${wintext}`].value
                    }
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
                            var seqIndex = BCC.counter.now.loss - 1
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
                    BCC[type].current = parseFloat((parseFloat(BCC[type].current)).toFixed(BCC.NCS(type)))
                });
            }
            if(BCC.Bet.current > BCC.wallet){
                BCC.Bet.current = BCC.wallet
            }
            log.info(`Place Bet: ${BCC.Bet.current} Payout: ${BCC.Payout.current}`)
        },
        jsonfile: [],
        LogThis: function(){
            var temp = BCC.GetObjectAsString({
                Odds: BCC.Odds.current, 
                wallet: BCC.wallet, 
                Bet_base: BCC.Bet.base, 
                Bet_moonBase: BCC.Bet.moonBase, 
                Bet_current: BCC.Bet.current, 
                Payout_base: BCC.Payout.base, 
                Payout_moonBase: BCC.Payout.moonBase, 
                Payout_current: BCC.Payout.current, 
                Counter_now_win: BCC.counter.now.win,
                Counter_now_loss: BCC.counter.now.loss,
                Counter_now_red: BCC.counter.now.red,
                Counter_now_green: BCC.counter.now.green,
                Counter_now_noyellow: BCC.counter.now.noyellow,
                Counter_all_win: BCC.counter.all.win,
                Counter_all_loss: BCC.counter.all.loss,
                Counter_all_red: BCC.counter.all.red,
                Counter_all_green: BCC.counter.all.green,
                Counter_all_yellow: BCC.counter.all.yellow,
                moonBetting: BCC.moonBetting, 
                placebet: BCC.placebet
            })
            BCC.jsonfile.push(temp)
            //log.success(temp)
        },
        save: function(){
            if ('Blob' in window) {
                var fileName = 'BCGameTest.json';
                var text = ""
                BCC.jsonfile.forEach((a, index, arra) => { 
                    text += `{${a}},\n`
                })
                var JStextToWrite = `[\n${text}]` 
                var typ = 'application/javascript'
                var textFileAsBlob = new Blob([JStextToWrite], { type: typ });
            
                if ('msSaveOrOpenBlob' in navigator) {
                    navigator.msSaveOrOpenBlob(textFileAsBlob, fileName);
                } 
                else {
                    var downloadLink = document.createElement('a');
                    downloadLink.download = fileName;
                    downloadLink.innerHTML = 'Download File';
                    if ('webkitURL' in window) {
                        // Chrome allows the link to be clicked without actually adding it to the DOM.
                        downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
                    }
                    else {
                        // Firefox requires the link to be added to the DOM before it can be clicked.
                        downloadLink.href = window.URL.createObjectURL(textFileAsBlob);
                        downloadLink.onclick = function (event) {document.body.removeChild(event.target);};
                        downloadLink.style.display = 'none';
                        document.body.appendChild(downloadLink);
                    }
                    downloadLink.click();
                }
            }
            else {
                alert('Your browser does not support the HTML5 Blob.');
            }
        },
        GoThruTemp: function(){
            BCC.Odds.temp.forEach((odds, index, arr) => { 
                BCC.Calculate(odds)
                BCC.LogThis()
            })
            log.success(`wallet: ${BCC.wallet}`)
            //BCC.save()
        },
        LogObject: function(data){
            Object.keys(data).forEach((j, i) => { 
                log.success(`${j}: ${data[j]}`);
            });
        },
        Reset: function(data){
            BCC.placebet = false;
            BCC.wallet = currency.amount;
            BCC.Odds = {
                all: [],
                temp: BCC.Odds.temp,
                temp2: BCC.Odds.temp2,
                temp3: BCC.Odds.temp3,
                current: 1.0
            };
            BCC.counter = {
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
            };
            BCC.moonBetting = false;
            BCC.Bet = {
                base: config.baseBet.value, 
                current: config.baseBet.value,
                Win: 0,
                Loss: 0,
                moonBase: config.moonBet.value,
                moonLoss: config.moonBetSeq.value
            };
            BCC.Payout = {
                base: config.basePayout.value, 
                current: config.basePayout.value,
                Win: 0,
                Loss: 0,
                moonBase: config.moonPayout.value,
                moonLoss: config.moonPayoutSeq.value
            };
            BCC.InitVars()
        },
        SetCurrency: function(name){
            switch(name){
                case 'JB':{
                    currency = {
                        minAmount: 1,
                        maxAmount: 2000,
                        amount: 10000,
                        currencyName: "JB"
                    }
                    break;
                }
                case 'BCD':{
                    currency = {
                        minAmount: 0.000001,
                        maxAmount: 20000,
                        amount: 0.04,
                        currencyName: "BCD"
                    }
                    break;
                }
            }
        }
    }
    BCC.InitVars()
    BCC.GoThruTemp()
//     game.onBet = function () {
//         if(BCC.dobet && BCC.placebet){
//          game.bet(BCC.Bet.current, BCC.Payout.current).then(function (payout){
//              //log.success(`Won: ${payout}`)
//             })
//         }
//     }
    
//     engine.on('GAME_ENDED', function (data){
//         BCC.Calculate(data.odds)
//     });
// }