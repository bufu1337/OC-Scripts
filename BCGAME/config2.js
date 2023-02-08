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