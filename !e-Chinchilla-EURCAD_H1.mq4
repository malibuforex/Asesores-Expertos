
#property copyright "© 2007, BJF Trading Group"
#property link      "www.iticsoftware.com"

#include <stdlib.mqh>
#include <stderror.mqh>

#define major   1
#define minor   2

extern string _tmp1_ = " --- Trade section ---";
extern double Lots = 0.1;
extern bool SmartLot = true;
extern int StopLoss = 83;
extern int TakeProfit = 25;
extern int dy0 = 20;
extern int dy1 = 30;
extern int dy2 = 40;
extern int Slippage = 3;
extern int Magic = 111111;

extern string _tmp2_ = " --- Time section ---";
extern int GMTDiff = 1;
extern int OpenH = 20;
extern int LifeTimeHPos = 13;
extern int LifeTimeHNeg = 19;
extern int ExpiredH = 10;

extern string _tmp3_ = " --- Trailing section ---";
extern bool UseTrailing = false;
extern int Profit4Start = 30;
extern int TrailingStop = 30;
extern int TrailingStep = 5;

extern string _tmp4_ = " --- Orders color ---";
extern color clBuy = DodgerBlue;
extern color clSell = Crimson;
extern color clModify = Silver;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void init () 
{
  if (!IsTesting()) Comment("");  
}

void deinit() 
{
  if (!IsTesting()) Comment("");
}

void start() 
{
  if (!IsTesting()) Comment("Time: ", TimeToStr(CurTime(), TIME_DATE|TIME_SECONDS));

  if (Period() != PERIOD_H1) {
    Comment(Symbol() + ": PERIOD_H1 expected!");
    return (-1);
  }  

  if (!IsTradeAllowed()) {
    Comment(Symbol() + ": trade is not allowed!");
    return (-1);
  }


  //-----
  
  if (UseTrailing) TrailingPositions();  

  //-----

  int cnt = OrdersTotal();
  for (int i=cnt-1; i >= 0; i--) 
  {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
    if (OrderSymbol() != Symbol()) continue;
    if (OrderMagicNumber() != Magic) continue;
  
    if (TimeCurrent() - OrderOpenTime() < LifeTimeHPos*60*60) continue;
    if (OrderProfit() < 0) continue;
  
    int type = OrderType();
    if (type == OP_BUY) 
    {
      RefreshRates();
      CloseOrder(OrderTicket(), OrderLots(), Bid, Slippage);
      continue;
    }
  
    if (type == OP_SELL) 
    {
      RefreshRates();
      CloseOrder(OrderTicket(), OrderLots(), Ask, Slippage);
      continue;
    }    
  }

  cnt = OrdersTotal();
  for (i=cnt-1; i >= 0; i--) 
  {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
    if (OrderSymbol() != Symbol()) continue;
    if (OrderMagicNumber() != Magic) continue;
  
    if (TimeCurrent() - OrderOpenTime() < LifeTimeHNeg*60*60) continue;
    if (OrderProfit() > 0) continue;
  
    type = OrderType();
    if (type == OP_BUY) 
    {
      RefreshRates();
      CloseOrder(OrderTicket(), OrderLots(), Bid, Slippage);
      continue;
    }
  
    if (type == OP_SELL) 
    {
      RefreshRates();
      CloseOrder(OrderTicket(), OrderLots(), Ask, Slippage);
      continue;
    }    
  }
        
  //-----
  
  int BuyCnt = 0;
  int SellCnt = 0;
  int BuyLimitCnt = 0;
  int SellLimitCnt = 0;
  
  cnt = OrdersTotal();
  for (i=0; i < cnt; i++) 
  {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
    if (OrderSymbol() != Symbol()) continue;
    if (OrderMagicNumber() != Magic) continue;
       
    type = OrderType();
    if (type == OP_BUY) BuyCnt++;
    if (type == OP_SELL) SellCnt++;
    if (type == OP_BUYLIMIT) BuyLimitCnt++;
    if (type == OP_SELLLIMIT) SellLimitCnt++;
  }
  
  //-----

  if (DayOfWeek() == 5) return;

  double price, sl, tp;
  string msg;
  
  int StopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL) + 1;
     
  if (Hour() == GMT(OpenH, GMTDiff)) 
  {
    if (BuyCnt > 0 || BuyLimitCnt > 0) return;
    
    bool b = false;
    double h0 = iHigh(NULL, PERIOD_D1, 0)-iLow(NULL, PERIOD_D1, 0);
    double h1 = iHigh(NULL, PERIOD_D1, 2)-iLow(NULL, PERIOD_D1, 2);
  
    b = (h0 <= h1);
    
    price = Ask - dy0*Point;
    if (b) price -= 1.3*(h1-h0);
    else price -= 1.3*(h0-h1);
    
    if (Ask-price < StopLevel*Point) price = Ask - StopLevel*Point;

    //price = Ask - k*w;
    sl = IIF(StopLoss > 0, price - StopLoss*Point, 0);
    tp = IIF(TakeProfit > 0, price + TakeProfit*Point, 0);

    if (b) tp += 1*(h1-h0);
    else tp -= 1*(h0-h1);

    //tp = 0.5*(h-l);
    if (tp < price) tp = price + 2*StopLevel*Point;

    SetBuyLimit(Symbol(), GetLots(), price, sl, tp, Magic, "", TimeCurrent() + ExpiredH*60*60);

    //price = Ask - k*w - dy*Point;
    price = Ask - dy1*Point;
    if (b) price -= 1.3*(h1-h0);
    
    if (Ask-price < StopLevel*Point) price = Ask - StopLevel*Point;
    
    sl = IIF(StopLoss > 0, price - StopLoss*Point, 0);
    tp = IIF(TakeProfit > 0, price + (TakeProfit+0)*Point, 0);
    
    if (tp < price) tp = price + 2*StopLevel*Point;
    
    SetBuyLimit(Symbol(), GetLots(), price, sl, tp, Magic, "", TimeCurrent() + ExpiredH*60*60);

    //price = Ask - k*w - dy2*Point;
    price = Ask - dy2*Point;
    if (b) price -= 1.3*(h1-h0);
    
    if (Ask-price < StopLevel*Point) price = Ask - StopLevel*Point;
    
    sl = IIF(StopLoss > 0, price - StopLoss*Point, 0);
    tp = IIF(TakeProfit > 0, price + (TakeProfit+0)*Point, 0);
    
    if (tp < price) tp = price + 2*StopLevel*Point;
    
    SetBuyLimit(Symbol(), GetLots(), price, sl, tp, Magic, "", TimeCurrent() + ExpiredH*60*60);

  }
  
  return;

  if (Hour() == GMT(OpenH, GMTDiff))
  {
    if (SellCnt > 0 || SellLimitCnt > 0) return;
  
    price = Bid + dy0*Point;
    //price = Bid + k*w;
    sl = IIF(StopLoss > 0, price + StopLoss*Point, 0);
    tp = IIF(TakeProfit > 0, price - TakeProfit*Point, 0);  
    
    //tp = 0.5*(h-l);
    
    SetSellLimit(Symbol(), GetLots(), price, sl, tp, Magic, "", TimeCurrent() + ExpiredH*60*60);

    //price = Bid + k*w + dy*Point;
    price = Bid + dy1*Point;
    sl = IIF(StopLoss > 0, price + StopLoss*Point, 0);
    tp = IIF(TakeProfit > 0, price - (TakeProfit+0)*Point, 0);  
        
    SetSellLimit(Symbol(), GetLots(), price, sl, tp, Magic, "", TimeCurrent() + ExpiredH*60*60);

    //price = Bid + k*w + dy2*Point;
    price = Bid + dy2*Point;
    sl = IIF(StopLoss > 0, price + StopLoss*Point, 0);
    tp = IIF(TakeProfit > 0, price - (TakeProfit+0)*Point, 0);  
        
    SetSellLimit(Symbol(), GetLots(), price, sl, tp, Magic, "", TimeCurrent() + ExpiredH*60*60);

  }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

double IIF(bool cond, double val1, double val2) 
{
  if (cond) return (val1);
  return (val2);
}

int GMT(int hr, int diff) 
{
  int res = hr + diff;
  if (res < 0) res = 24 + res;
  if (res > 23) res = res - 24;
  
  return (res);
}

double GetLots() 
{
  if (SmartLot)
  {
    if (LastOrdersProfit(1) > 0) return (2*Lots);  
  }

  return (1*Lots);
}

double LastOrdersProfit(int ord_cnt) 
{
  double profit = 0;

  int cnt = OrdersHistoryTotal();
  for (int i=cnt-1; i >= 0; i--) 
  {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) continue;
    if (OrderSymbol() != Symbol()) continue;
    if (OrderMagicNumber() != Magic) continue;
    
    int type = OrderType();
    if (type == OP_BUY || type == OP_SELL)
    {
      profit += OrderProfit();
      ord_cnt--;
    }
    
    if (ord_cnt == 0) break;
  }
  
  return (profit);
}

void TrailingPositions() 
{
  int cnt = OrdersTotal();
  for (int i=0; i<cnt; i++) 
  {
    if (!(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))) continue;
    if (OrderSymbol() != Symbol()) continue;
    if (OrderMagicNumber() != Magic) continue;

    if (OrderType() == OP_BUY) 
    {
      if (Bid-OrderOpenPrice() > Profit4Start*Point) 
      {
        if (OrderStopLoss() < Bid-(TrailingStop+TrailingStep-1)*Point) 
        {
          OrderModify(OrderTicket(), OrderOpenPrice(), Bid-TrailingStop*Point, OrderTakeProfit(), 0, clModify);
        }
      }
    }

    if (OrderType() == OP_SELL) 
    {
      if (OrderOpenPrice()-Ask > Profit4Start*Point) 
      {
        if (OrderStopLoss() > Ask+(TrailingStop+TrailingStep-1)*Point || OrderStopLoss() == 0) 
        {
          OrderModify(OrderTicket(), OrderOpenPrice(), Ask+TrailingStop*Point, OrderTakeProfit(), 0, clModify);
        }
      }
    }
  }
  
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int SleepOk = 1000;
int SleepErr = 3000;

int SetBuyLimit(string symbol, double lot, double price, double sl, double tp, int magic, string comment="", datetime exp=0) 
{
  int dig = MarketInfo(symbol, MODE_DIGITS);

  price = NormalizeDouble(price, dig);
  sl = NormalizeDouble(sl, dig);
  tp = NormalizeDouble(tp, dig);
  
  string _lot = DoubleToStr(lot, 2);
  string _price = DoubleToStr(price, dig);
  string _sl = DoubleToStr(sl, dig);
  string _tp = DoubleToStr(tp, dig);

  Print("SetBuyLimit \"", symbol, "\", ", _lot, ", ", _price, ", ", Slippage, ", ", _sl, ", ", _tp, ", ", magic, ", \"", comment, "\"");
  
  int res = OrderSend(symbol, OP_BUYLIMIT, lot, price, Slippage, sl, tp, comment, magic, exp, clBuy);
  if (res >= 0) {
    Sleep(SleepOk);
    return (res);
  } 	
   	
  int code = GetLastError();
  Print("Error setting BUYLIMIT order: ", ErrorDescription(code), " (", code, ")");
  Sleep(SleepErr);
	
  return (-1);
}

int SetSellLimit(string symbol, double lot, double price, double sl, double tp, int magic, string comment="", datetime exp=0) 
{
  int dig = MarketInfo(symbol, MODE_DIGITS);

  price = NormalizeDouble(price, dig);
  sl = NormalizeDouble(sl, dig);
  tp = NormalizeDouble(tp, dig);
  
  string _lot = DoubleToStr(lot, 2);
  string _price = DoubleToStr(price, dig);
  string _sl = DoubleToStr(sl, dig);
  string _tp = DoubleToStr(tp, dig);

  Print("SetSellLimit \"", symbol, "\", ", _lot, ", ", _price, ", ", Slippage, ", ", _sl, ", ", _tp, ", ", magic, ", \"", comment, "\"");
  
  int res = OrderSend(symbol, OP_SELLLIMIT, lot, price, Slippage, sl, tp, comment, magic, exp, clSell);
  if (res >= 0) {
    Sleep(SleepOk);
    return (res);
  } 	
   	
  int code = GetLastError();
  Print("Error setting SELLLIMIT order: ", ErrorDescription(code), " (", code, ")");
  Sleep(SleepErr);
	
  return (-1);
}

bool CloseOrder(int ticket, double lot, double price, int Slippage) 
{
  if (!OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) return(false);
  int dig = MarketInfo(OrderSymbol(), MODE_DIGITS);

  string _lot = DoubleToStr(lot, 1);
  string _price = DoubleToStr(price, dig);

  Print("CloseOrder ", ticket, ", ", _lot, ", ", _price, ", ", Slippage);
  
  bool res = OrderClose(ticket, lot, price, Slippage);
  if (res) {
    Sleep(SleepOk);
    return (res);
  } 	
   	
  int code = GetLastError();
  Print("CloseOrder failed: ", ErrorDescription(code), " (", code, ")");
  Sleep(SleepErr);
	
  return (false);
}

