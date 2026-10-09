# SSL Hybrid Backtester - Usage Guide

## Quick Start

### 1. Launch Application
```bash
flutter run --release
```

### 2. Main Navigation
The app has three main sections:

#### **Data Tab** 📥
- Upload CSV files with historical price data
- Select instrument and timeframe
- Verify data is loaded correctly

#### **Strategy Tab** ⚙️
- Configure SSL Hybrid parameters
- Adjust MA types and lengths
- Fine-tune ATR settings
- Reset to defaults anytime

#### **Results Tab** 📊
- View backtest results
- Analyze performance metrics
- Review all trades
- Export results

---

## Detailed Workflows

### Workflow 1: Basic Backtest (5 minutes)

**Step 1: Prepare Data**
1. Open app → Data tab
2. Select Instrument: **XAUUSD** (Gold)
3. Select Timeframe: **1D** (Daily)
4. Click Upload → Select CSV file
   - Format: `datetime,open,high,low,close,volume`
5. Click Load Data → Verify success

**Step 2: Configure Strategy**
1. Go to Strategy tab
2. Keep default parameters (recommended for beginners)
3. Review settings:
   - SSL1 Type: HMA, Length: 60
   - SSL2 Type: JMA, Length: 5
   - SSL3 Type: HMA, Length: 15
   - ATR Period: 14, Multiplier: 1.0

**Step 3: Run Backtest**
1. Go to Results tab
2. Click "Run Backtest"
3. Wait for calculation (1-30 seconds depending on data size)
4. Review results

**Step 4: Export Results**
1. Click "Export Results"
2. Choose format (CSV)
3. Save to device storage

---

### Workflow 2: Advanced Analysis & Optimization

**Step 1: Test Different Timeframes**
```
1. Backtest on Daily (1D)
2. Compare results
3. Then test on 4H
4. Compare performance across timeframes
```

**Step 2: Parameter Optimization**
```
SSL1 Length:
- Try: 50, 60, 70 (longer = more trades, smoother)

SSL2 Length:
- Try: 3, 5, 7 (shorter = more continuation trades)

ATR Multiplier:
- Try: 0.8, 1.0, 1.2 (affects range size)
```

**Step 3: Compare Results**
```
For each setting, track:
✓ Win Rate (higher is better)
✓ Profit Factor (>1.5 is good)
✓ Max Drawdown (lower is better)
✓ Sharpe Ratio (>1.0 is good)
```

**Step 4: Document Best Settings**
1. Screenshot optimal parameters
2. Export results with metadata
3. Save settings configuration

---

## Understanding Metrics

### Performance Metrics

| Metric | Definition | Good Value | Interpretation |
|--------|-----------|------------|----------------|
| **Win Rate** | % of winning trades | >50% | Higher = better consistency |
| **Profit Factor** | Total Gains / Total Losses | >1.5 | >1.0 means profitable |
| **Total Profit** | Sum of all P&L | >0 | Overall profitability |
| **Max Drawdown** | Largest peak-to-trough decline | <20% | Risk measure |
| **Sharpe Ratio** | Risk-adjusted returns | >1.0 | Higher = better risk/reward |
| **Return on Risk** | Profit / Maximum Loss | >2.0 | Profit vs. maximum risk |

### Trade Information

Each trade shows:
- **Entry Time**: When position opened
- **Entry Price**: Price at entry
- **Exit Time**: When position closed
- **Exit Price**: Price at exit
- **P&L**: Profit or Loss in currency
- **P&L %**: Return as percentage
- **Status**: WIN or LOSS indicator

---

## Data Management

### Importing CSV Data

**Recommended Format:**
```csv
datetime,open,high,low,close,volume
2023-01-01 00:00:00,2050.50,2055.00,2048.00,2052.00,10000
2023-01-02 00:00:00,2052.00,2060.00,2051.00,2058.00,12000
```

**Data Size Recommendations:**
- Minimum: 50 candles
- Recommended: 500-2000 candles (2-10 years daily)
- Maximum: 10,000+ (will be slower)

### Multiple Datasets
1. Each backtest is saved automatically
2. Access from Results tab → History
3. Compare multiple backtests
4. Delete old results to free space

---

## Strategy Explanation

### SSL Hybrid NNFX Method

**What it does:**
- Uses three exponential moving averages (or selected type)
- Identifies trend direction and continuations
- Generates entry and exit signals
- Measures volatility with ATR bands

**Key Components:**

1. **SSL1 (Baseline)**
   - Primary trend indicator
   - Longer period (default 60)
   - Generates main entry signals

2. **SSL2 (Continuation)**
   - Confirmation filter
   - Shorter period (default 5)
   - Filters fake signals
   - Identifies continuation trades

3. **SSL3 (Exit)**
   - Exit signal generator
   - Medium period (default 15)
   - Closes positions at reversal

4. **ATR (Volatility)**
   - Measures market volatility
   - Sets position size (theoretical)
   - Defines trading ranges

**Signal Generation:**
```
BUY Signal:
  ✓ Price crosses above SSL1
  ✓ Confirmed by SSL2 position
  ✓ Within ATR bands

SELL Signal:
  ✓ Price crosses below SSL1
  ✓ Confirmed by SSL2 position
  ✓ Within ATR bands

EXIT:
  ✓ Price crosses SSL3 in opposite direction
  ✓ Locks in profit or cuts loss
```

---

## Tips & Best Practices

### ✓ Do's
- Start with 1D timeframe for beginners
- Use minimum 500 candles for reliable results
- Test on different market conditions
- Keep daily backtest results for comparison
- Export and archive successful strategies
- Document your best parameter sets

### ✗ Don'ts
- Don't use less than 50 candles
- Don't over-optimize (overfitting risk)
- Don't expect same results in live trading
- Don't ignore drawdown metrics
- Don't test only bull markets
- Don't change multiple parameters at once

### Optimization Tips

**Systematic Testing:**
```
1. Test one parameter at a time
2. Keep others at default
3. Record all results
4. Compare metrics
5. Choose best setting
6. Move to next parameter
```

**Market Conditions:**
- Test in trending market (2020-2021)
- Test in ranging market (2022)
- Test in volatile market (2023)
- Test across cycles

---

## Troubleshooting

### Issue: "File not found"
- Ensure CSV file is in app-accessible directory
- Check file permissions
- Verify file format is CSV
- Try selecting file again

### Issue: "No results after backtest"
- Verify data has at least 100 candles
- Check data format is correct
- Ensure prices are realistic numbers
- Try with sample data first

### Issue: "App runs slowly"
- Close background apps
- Use Release build mode
- Reduce dataset size
- Restart app and device

### Issue: "Can't upload file"
- Grant storage permissions
- Use different file manager
- Try smaller CSV file
- Clear app cache: Settings > Apps > SSL Backtester > Storage > Clear Cache

---

## Export & Sharing

### Export Results
1. Results tab → Complete backtest
2. Click "Export Results"
3. Format options:
   - CSV: For Excel analysis
   - PDF: For reports
   - JSON: For data processing

### Share Strategy
1. Settings → Export Strategy
2. Share configuration file
3. Others can import and use

### Backup Data
```bash
# Export all results
Settings → Backup → Export All

# Restore from backup
Settings → Backup → Import
```

---

## Advanced Features (Future Updates)

- [ ] Multi-strategy comparison
- [ ] Walk-forward analysis
- [ ] Monte Carlo simulation
- [ ] Live trading integration
- [ ] Cloud sync
- [ ] Alerts on strategy signals
- [ ] Portfolio analysis
- [ ] Risk management tools

---

## FAQ

**Q: Can I use this for live trading?**
A: Currently for backtesting only. Live trading integration coming in v2.0.

**Q: What's the minimum data required?**
A: Minimum 50 candles, recommended 500+ for reliable results.

**Q: Can I test multiple instruments?**
A: Yes, supports XAUUSD, EURUSD, GBPUSD, USDJPY, AUDUSD.

**Q: How accurate are results?**
A: Highly accurate for historical data. Live results may differ due to slippage and commissions.

**Q: Can I export to Excel?**
A: Yes, export as CSV and open in Excel.

**Q: Is my data private?**
A: All data stays on your device. No cloud storage by default.

---

**Last Updated**: 2024
**Version**: 1.0.0
