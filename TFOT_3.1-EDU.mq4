/*
   Generated by EX4-TO-MQ4 decompiler V4.0.409.1b [-]
   Website: https://purebeam.biz
   E-mail : purebeam@gmail.com
	
	2011-11-28 Educated by Capella
	- Moved DLL-functions to mq4-code
	- Removed restrictions
	
	2011-12-18 Enhanced Version by derox
   - Enabled all external variables
	- cleaned code and renamed variables
*/
#property copyright "Copyright � 2010 - 2011, BJF Trading Group inc."
#property link      "http://iticsoftware.com/tfot"


#import "Kernel32.dll"
   void GetSystemTime(int& a0[]);
#import

//bool EnableUSDCADSettings = TRUE;
extern bool FirstFace = TRUE;
extern bool SecondFace = TRUE;
extern bool MarketExecution = FALSE;
extern string CommentsFirst = "First Face";
extern string CommentsSecond = "Second Face";
extern int MagicFirst = 125566;
extern int MagicSecond = 125563;
extern double MaxSPREAD = 4.0;
extern int Slippage = 2;
extern bool GMTAuto = TRUE;
extern int GMTTest = 2;
extern bool DoublingTrade = FALSE;
extern string MM = "==== MM Parameters ====";
extern double PercentAllMax = 100.0;
extern double MaxLotsOr = 5.0;
//extern bool SimpleLotsPercentCalculation = FALSE;
extern string FFMP = "==== First Face MM Parameters ====";
extern double LotFF = 1.0;
extern double PercentLotFF = 0.0;
extern double LotMultiplierFF = 2.0;
extern int MultiplyAfterLosingTradesFF = 0;
extern int MultiplyNextOrdersFF = 2;
int DifferenceToCountAsLoserFF = 0;
extern string FFSP = "==== First Face System Parameters ====";
extern int StopLoss = 150;
extern int TakeProfit = 23;
extern int SMMAPeriod = 60;
extern int SMMADistance = 20;
extern int WPRPeriod = 18;
extern int WPRAllLevel = 6;
extern int WPRTopLevel = 10;
extern int WPRBottomLevel = 13;
extern int CloseDistance = -5;
extern int FFHour1 = 21;
extern string SFMP = "==== Second Face MM Parameters ====";
extern double LotSF = 1.0;
extern double PercentLotSF = 0.0;
extern double LotMultiplierSF = 2.0;
extern int MultiplyAfterLosingTradesSF = 0;
extern int MultiplyNextOrdersSF = 2;
int DifferenceToCountAsLoserSF = 0;
extern string SFSP = "==== Second Face System Parameters ====";
extern int TakeProfit2 = 550;
extern int StopLoss2 = 33;
extern int MaxTrall = 165;
extern int MinTrall = 12;
extern int EMAPeriod = 1;
extern int ATRPeriod = 19;
extern double ATRMultiplier = 4.7;
extern int MinTrailWaitingTime = 300;
extern int TrailingStart = 270;
extern int TrailingStep = 20;
int SFHour1 = 0;
int SFHour2 = 8;
int SFHour3 = 7;
int SFHour4 = 18;
int SFHour5 = 17;
int SFHour6 = 13;
int SFHour7 = 14;
int SFHour8 = 6;
int SFHour9 = 9;
int SFHour10 = 2;
int SFHour11 = 3;

bool ForceBrokerInfos = TRUE;
string gmttime = "";
double brokerminlot = 0.0;
double brokermaxlot = 0.0;
double brokerlotstep = 0.0;
int brokerleverage = 0;
int brokerlotsize = 0;
int brokerstoplevel = 0;
int ordermodifytime = 0;
double closem15;
double smmam15;
double wprm15;
double emah1;
double atrh1;
double closem5;
double pipvalue;
int ticketcopy = -1;
double calcone;
double calctwo;

/*
void USDCADSettings() {
   if (StringFind(Symbol(), "USDCAD", 0) != -1 && EnableUSDCADSettings) {
      StopLoss = 120;
      TakeProfit = 18;
      SMMAPeriod = 28;
      SMMADistance = 7;
      WPRPeriod = 18;
      WPRTopLevel = 33;
      WPRBottomLevel = 5;
      CloseDistance = FALSE;
      FFStartHour = 21;
      WPRAllLevel = 34;
      TakeProfit2 = 369;
      StopLoss2 = 32;
      MaxTrall = 165;
      MinTrall = 12;
      EMAPeriod = 9;
      ATRPeriod = 23;
      ATRMultiplier = 4.7;
   }
}
*/

int init() {
   ForceBrokerInfos = TRUE;
   Comment("");
   int remainder = 1;
// USDCADSettings();
   return (0);
}

int deinit() {
   Comment("");
   return (0);
}

int start() {
   double orderprice;
   double orderstoploss;
   double ordertakeprofit;
   color ordercolor;
   bool ret;
   int timezone;
   int ticketfirst;
   int ticketsecond;
   double firstsl;
   double firsttp;
   double secondsl;
   double secondtp;
   double atrmultiplied;
   double trailingprice;
   double lotsfirst;
   string ordercomment;
   double lotssecond;
   GetBrokerInfos();
   CalculateMinimumSLTP();
   Indicators();
   if (!IsTesting() && GMTAuto == TRUE) timezone = CalculateGMT();
   else timezone = GMTTest;
   Comment("AccountNumber= ", AccountNumber(), 
      "\n", "AccountName= ", AccountName(), 
      "\n", "AccountBalance= ", AccountBalance(), 
      "\n", "Spread= ", DoubleToStr((Ask - Bid) / pipvalue, 1), 
      "\n", "TimeZONE= ", timezone, 
   "\n");
   int ffhour1gmt = FFHour1 + timezone;
   int ffhour2gmt = FFHour1 + timezone;
   if (ffhour1gmt > 23) ffhour1gmt -= 24;
   if (ffhour1gmt < 0) ffhour1gmt += 24;
   if (ffhour2gmt > 23) ffhour2gmt -= 24;
   if (ffhour2gmt < 0) ffhour2gmt += 24;
   int sfhour1gmt = SFHour1 + timezone;
   int sfhour2gmt = SFHour2 + timezone;
   int sfhour3gmt = SFHour3 + timezone;
   int sfhour4gmt = SFHour4 + timezone;
   int sfhour5gmt = SFHour5 + timezone;
   int sfhour6gmt = SFHour6 + timezone;
   int sfhour7gmt = SFHour7 + timezone;
   int sfhour8gmt = SFHour8 + timezone;
   int sfhour9gmt = SFHour9 + timezone;
   int sfhour10gmt = SFHour10 + timezone;
   int sfhour11gmt = SFHour11 + timezone;
   if (sfhour1gmt > 23) sfhour1gmt -= 24;
   if (sfhour1gmt < 0) sfhour1gmt += 24;
   if (sfhour2gmt > 23) sfhour2gmt -= 24;
   if (sfhour2gmt < 0) sfhour2gmt += 24;
   if (sfhour3gmt > 23) sfhour3gmt -= 24;
   if (sfhour3gmt < 0) sfhour3gmt += 24;
   if (sfhour4gmt > 23) sfhour4gmt -= 24;
   if (sfhour4gmt < 0) sfhour4gmt += 24;
   if (sfhour5gmt > 23) sfhour5gmt -= 24;
   if (sfhour5gmt < 0) sfhour5gmt += 24;
   if (sfhour6gmt > 23) sfhour6gmt -= 24;
   if (sfhour6gmt < 0) sfhour6gmt += 24;
   if (sfhour7gmt > 23) sfhour7gmt -= 24;
   if (sfhour7gmt < 0) sfhour7gmt += 24;
   if (sfhour8gmt > 23) sfhour8gmt -= 24;
   if (sfhour8gmt < 0) sfhour8gmt += 24;
   if (sfhour9gmt > 23) sfhour9gmt -= 24;
   if (sfhour9gmt < 0) sfhour9gmt += 24;
   if (sfhour10gmt > 23) sfhour10gmt -= 24;
   if (sfhour10gmt < 0) sfhour10gmt += 24;
   if (sfhour11gmt > 23) sfhour11gmt -= 24;
   if (sfhour11gmt < 0) sfhour11gmt += 24;
   Slippage = Slippage * pipvalue;
   int countbuysfirst = 0;
   int countsellsfirst = 0;
   int countbuyssecond = 0;
   int countsellssecond = 0;
   int timestamp = ordermodifytime;
   int lasttrailmodify = ordermodifytime + MinTrailWaitingTime;
   int stoplevel = MarketInfo(Symbol(), MODE_STOPLEVEL);
   SelectOrders();
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) Print("OrderSelect Error! Position:", i);
      else {
         if (OrderType() <= OP_SELL && OrderSymbol() == Symbol()) {
            if (OrderMagicNumber() == MagicFirst) {
               if (OrderType() == OP_BUY) {
                  if (OrderStopLoss() == 0.0) {
                     firstsl = NormalizeDouble(Ask - StopLoss * pipvalue, Digits);
                     firsttp = NormalizeDouble(Ask + TakeProfit * pipvalue, Digits);
                     if (CheckStop(OrderType(), firstsl, stoplevel, Bid, Ask, Point) && CheckTarget(OrderType(), firsttp, stoplevel, Bid, Ask, Point)) OrderModify(OrderTicket(), OrderOpenPrice(), firstsl, firsttp, 0, Green);
                  }
                  if (wprm15 > (-WPRBottomLevel) && Bid > closem15 + CloseDistance * pipvalue) {
                     RefreshRates();
                     OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), Slippage, Violet);
                     if (!IsTesting()) Sleep(5000);
                     CheckLastOrder();
                  } else countbuysfirst++;
               } else {
                  if (OrderStopLoss() == 0.0) {
                     firstsl = NormalizeDouble(Bid + StopLoss * pipvalue, Digits);
                     firsttp = NormalizeDouble(Bid - TakeProfit * pipvalue, Digits);
                     if (CheckStop(OrderType(), firstsl, stoplevel, Bid, Ask, Point) && CheckTarget(OrderType(), firsttp, stoplevel, Bid, Ask, Point)) OrderModify(OrderTicket(), OrderOpenPrice(), firstsl, firsttp, 0, Green);
                  }
                  if (wprm15 < WPRBottomLevel + (-100) && Bid < closem15 - CloseDistance * pipvalue) {
                     RefreshRates();
                     OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), Slippage, Violet);
                     if (!IsTesting()) Sleep(5000);
                     CheckLastOrder();
                  } else countsellsfirst++;
               }
            }
            if (OrderMagicNumber() == MagicSecond) {
               if (OrderType() == OP_BUY) {
                  if (OrderStopLoss() == 0.0) {
                     secondsl = NormalizeDouble(Ask - StopLoss2 * pipvalue, Digits);
                     secondtp = NormalizeDouble(Ask + TakeProfit2 * pipvalue, Digits);
                     if (CheckStop(OrderType(), secondsl, stoplevel, Bid, Ask, Point) && CheckTarget(OrderType(), secondtp, stoplevel, Bid, Ask, Point)) OrderModify(OrderTicket(), OrderOpenPrice(), secondsl, secondtp, 0, Green);
                  }
                  if (closem5 <= cond2(pipvalue)) {
                     RefreshRates();
                     OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), Slippage, Violet);
                  } else countbuyssecond++;
                  if (TimeCurrent() < lasttrailmodify) continue;
                  atrmultiplied = atrh1 * ATRMultiplier;
                  if (atrmultiplied > MaxTrall * pipvalue) atrmultiplied = MaxTrall * pipvalue;
                  if (atrmultiplied < MinTrall * pipvalue) atrmultiplied = MinTrall * pipvalue;
                  if (Bid - OrderOpenPrice() > TrailingStart * pipvalue) atrmultiplied = TrailingStep * pipvalue;
                  trailingprice = NormalizeDouble(Bid - atrmultiplied, Digits);
                  if (Bid - OrderOpenPrice() <= atrmultiplied) continue;
                  if (!(OrderStopLoss() < trailingprice && CheckStop(OrderType(), trailingprice, stoplevel, Bid, Ask, Point))) continue;
                  ret = OrderModify(OrderTicket(), OrderOpenPrice(), trailingprice, OrderTakeProfit(), 0, Blue);
                  if (!(ret)) continue;
                  timestamp = TimeCurrent();
                  ordermodifytime = timestamp;
                  continue;
               } // else {
               if (OrderStopLoss() == 0.0) {
                  secondsl = NormalizeDouble(Bid + StopLoss2 * pipvalue, Digits);
                  secondtp = NormalizeDouble(Bid - TakeProfit2 * pipvalue, Digits);
                  if (CheckStop(OrderType(), secondsl, stoplevel, Bid, Ask, Point) && CheckTarget(OrderType(), secondtp, stoplevel, Bid, Ask, Point)) OrderModify(OrderTicket(), OrderOpenPrice(), secondsl, secondtp, 0, Green);
               }
               if (closem5 >= cond1(pipvalue)) {
                  RefreshRates();
                  OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), Slippage, Violet);
               } else countsellssecond++;
               if (TimeCurrent() >= lasttrailmodify) {
                  atrmultiplied = atrh1 * ATRMultiplier;
                  if (atrmultiplied > MaxTrall * pipvalue) atrmultiplied = MaxTrall * pipvalue;
                  if (atrmultiplied < MinTrall * pipvalue) atrmultiplied = MinTrall * pipvalue;
                  if (OrderOpenPrice() - Ask > TrailingStart * pipvalue) atrmultiplied = TrailingStep * pipvalue;
                  trailingprice = NormalizeDouble(Ask + atrmultiplied, Digits);
                  if (OrderOpenPrice() - Ask > atrmultiplied) {
                     if (OrderStopLoss() > trailingprice && CheckStop(OrderType(), trailingprice, stoplevel, Bid, Ask, Point)) {
                        ret = OrderModify(OrderTicket(), OrderOpenPrice(), trailingprice, OrderTakeProfit(), 0, Red);
                        if (ret) {
                           timestamp = TimeCurrent();
                           ordermodifytime = timestamp;
                        }
                     }
                  }
               }
            }
         }
      }
   }
   int ordertype = -1;
   if (FirstFace != FALSE) {
      if (LotFF != 0.0) {
         lotsfirst = MathMin(brokermaxlot, MathMax(brokerminlot, LotFF));
         if (PercentLotFF > 0.0) lotsfirst = MathMax(brokerminlot, MathMin(brokermaxlot, NormalizeDouble(CalculateLotsFirst() / 100.0 * AccountFreeMargin() / brokerlotstep / (brokerlotsize / 100), 0) * brokerlotstep));
         if (lotsfirst > MaxLotsOr) lotsfirst = MaxLotsOr;
         if (AccountFreeMargin() < Ask * lotsfirst * brokerlotsize / brokerleverage) {
            Print("We have no money. Lots = ", lotsfirst, " , Free Margin = ", AccountFreeMargin());
            Comment("We have no money. Lots = ", lotsfirst, " , Free Margin = ", AccountFreeMargin());
            return (0);
         }
         if (countbuysfirst < 1 && (closem15 > smmam15 + SMMADistance * pipvalue && wprm15 < WPRTopLevel + (-100) && Bid < closem15 - CloseDistance * pipvalue) || (wprm15 < WPRAllLevel + (-100) && Bid < closem15 - CloseDistance * pipvalue && Hour() == ffhour1gmt || Hour() == ffhour2gmt)) {
            ordercomment = "BUY";
            ordertype = 0;
            ordercolor = Green;
            RefreshRates();
            orderprice = NormalizeDouble(Ask, Digits);
            orderstoploss = orderprice - StopLoss * pipvalue;
            ordertakeprofit = orderprice + TakeProfit * pipvalue;
         }
         if (countsellsfirst < 1 && (closem15 < smmam15 - SMMADistance * pipvalue && wprm15 > (-WPRTopLevel) && Bid > closem15 + CloseDistance * pipvalue) || (wprm15 > (-WPRAllLevel) && Bid > closem15 + CloseDistance * pipvalue && Hour() == ffhour1gmt || Hour() == ffhour2gmt)) {
            ordercomment = "SELL";
            ordertype = 1;
            ordercolor = Red;
            RefreshRates();
            orderprice = NormalizeDouble(Bid, Digits);
            orderstoploss = orderprice + StopLoss * pipvalue;
            ordertakeprofit = orderprice - TakeProfit * pipvalue;
         }
      }
   }
   if (ordertype >= OP_BUY && brokerstoplevel == 0 || (CheckStop(ordertype, orderstoploss, stoplevel, Bid, Ask, Point) && CheckTarget(ordertype, ordertakeprofit, stoplevel, Bid, Ask, Point))) {
      if (brokerstoplevel == 0 || MarketExecution == TRUE) ticketfirst = OrderSend(Symbol(), ordertype, lotsfirst, orderprice, Slippage, 0, 0, CommentsFirst, MagicFirst, 0, ordercolor);
      else ticketfirst = OrderSend(Symbol(), ordertype, lotsfirst, orderprice, Slippage, orderstoploss, ordertakeprofit, CommentsFirst, MagicFirst, 0, ordercolor);
      if (!IsTesting()) Sleep(5000);
      if (ticketfirst > 0) {
         if (OrderSelect(ticketfirst, SELECT_BY_TICKET, MODE_TRADES)) Print(CommentsFirst + " order " + ordercomment + " opened!: ", OrderOpenPrice());
      } else Print("Error opening " + ordercomment + " order!: ", GetLastError());
   }
   ordertype = -1;
   if ((!(TimeHour(TimeCurrent()) != sfhour1gmt && TimeHour(TimeCurrent()) != sfhour2gmt && TimeHour(TimeCurrent()) != sfhour3gmt && TimeHour(TimeCurrent()) != sfhour4gmt && TimeHour(TimeCurrent()) != sfhour5gmt && TimeHour(TimeCurrent()) != sfhour6gmt && TimeHour(TimeCurrent()) != sfhour7gmt && TimeHour(TimeCurrent()) != sfhour8gmt && TimeHour(TimeCurrent()) != sfhour10gmt && TimeHour(TimeCurrent()) != sfhour10gmt)) || !(TimeHour(TimeCurrent()) != sfhour11gmt)) {
      if (SecondFace != FALSE) {
         if (LotSF != 0.0) {
            lotssecond = MathMin(brokermaxlot, MathMax(brokerminlot, LotSF));
            if (PercentLotSF > 0.0) lotssecond = MathMax(brokerminlot, MathMin(brokermaxlot, NormalizeDouble(CalculateLotsSecond() / 100.0 * AccountFreeMargin() / brokerlotstep / (brokerlotsize / 100), 0) * brokerlotstep));
            if (lotssecond > MaxLotsOr) lotssecond = MaxLotsOr;
            if (AccountFreeMargin() < Ask * lotssecond * brokerlotsize / brokerleverage) {
               Print("We have no money. Lots = ", lotssecond, " , Free Margin = ", AccountFreeMargin());
               Comment("We have no money. Lots = ", lotssecond, " , Free Margin = ", AccountFreeMargin());
               return (0);
            }
            if (countsellssecond < 1 && closem5 <= cond2(pipvalue)) {
               ordercomment = "SELL";
               ordertype = 1;
               ordercolor = Gold;
               orderprice = NormalizeDouble(Bid, Digits);
               orderstoploss = orderprice + StopLoss2 * pipvalue;
               ordertakeprofit = orderprice - TakeProfit2 * pipvalue;
            }
            if (countbuyssecond < 1 && closem5 >= cond1(pipvalue)) {
               ordercomment = "BUY";
               ordertype = 0;
               ordercolor = Blue;
               orderprice = NormalizeDouble(Ask, Digits);
               orderstoploss = orderprice - StopLoss2 * pipvalue;
               ordertakeprofit = orderprice + TakeProfit2 * pipvalue;
            }
         }
      }
   }
   if (ordertype >= OP_BUY && brokerstoplevel == 0 || (CheckStop(ordertype, orderstoploss, stoplevel, Bid, Ask, Point) && CheckTarget(ordertype, ordertakeprofit, stoplevel, Bid, Ask, Point))) {
      if (brokerstoplevel == 0 || MarketExecution == TRUE) ticketsecond = OrderSend(Symbol(), ordertype, lotssecond, orderprice, Slippage, 0, 0, CommentsSecond, MagicSecond, 0, ordercolor);
      else ticketsecond = OrderSend(Symbol(), ordertype, lotssecond, orderprice, Slippage, orderstoploss, ordertakeprofit, CommentsSecond, MagicSecond, 0, ordercolor);
      if (!IsTesting()) Sleep(5000);
      if (ticketsecond > 0) {
         if (OrderSelect(ticketsecond, SELECT_BY_TICKET, MODE_TRADES)) Print(CommentsSecond + " order " + ordercomment + " opened!: ", OrderOpenPrice());
      } else Print("Error opening " + ordercomment + " order!: ", GetLastError());
   }
   ordertype = -1;
   return (0);
}

double CalculateLotsFirst() {
   int remainder;
   double pipvalue;
//   if (SimpleLotsPercentCalculation) return (PercentLotFF);
   double calclots = PercentLotFF;
   int countlosers = 0;
   if (Digits <= 3) pipvalue = 0.01;
   else pipvalue = 0.0001;
   for (int i = OrdersHistoryTotal(); i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
         if (OrderType() <= OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicFirst) {
            if (OrderProfit() > 0.0) {
               if (DifferenceToCountAsLoserFF == 0) break;
               if (MathAbs(OrderClosePrice() - OrderOpenPrice()) / pipvalue > DifferenceToCountAsLoserFF) break;
               continue;
            }
            countlosers++;
         }
      }
   }
   if (countlosers > MultiplyAfterLosingTradesFF && MultiplyNextOrdersFF > 1) {
      remainder = MathMod(countlosers, MultiplyNextOrdersFF);
      calclots *= MathPow(LotMultiplierFF, remainder);
   }
   if (PercentAllMax > 0.0 && calclots > PercentAllMax) calclots = PercentAllMax;
   return (calclots);
}

double CalculateLotsSecond() {
   int remainder;
   double pipvalue;
//   if (SimpleLotsPercentCalculation) return (PercentLotSF);
   double calclots = PercentLotSF;
   int countlosers = 0;
   if (Digits <= 3) pipvalue = 0.01;
   else pipvalue = 0.0001;
   for (int i = OrdersHistoryTotal(); i >= 0; i--) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
         if (OrderType() <= OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicSecond) {
            if (OrderProfit() > 0.0) {
               if (DifferenceToCountAsLoserSF == 0) break;
               if (MathAbs(OrderClosePrice() - OrderOpenPrice()) / pipvalue > DifferenceToCountAsLoserSF) break;
               continue;
            }
            countlosers++;
         }
      }
   }
   if (countlosers > MultiplyAfterLosingTradesSF && MultiplyNextOrdersSF > 1) {
      remainder = MathMod(countlosers, MultiplyNextOrdersSF);
      calclots *= MathPow(LotMultiplierSF, remainder);
   }
   if (PercentAllMax > 0.0 && calclots > PercentAllMax) calclots = PercentAllMax;
   return (calclots);
}

int CalculateGMT() {
   int buffer[4];
   GetSystemTime(buffer);
   int time1 = buffer[0] & 65535;
   int time2 = buffer[0] >> 16;
   int time3 = buffer[1] >> 16;
   int time4 = buffer[2] & 65535;
   int time5 = buffer[2] >> 16;
   int time6 = buffer[3] & 65535;
   string decodedtime = DecodeTime(time1, time2, time3, time4, time5, time6);
   double readabletime = TimeCurrent() - StrToTime(decodedtime);
   gmttime = "\n   Greenwich Mean Time : " + TimeToStr(StrToTime(decodedtime), TIME_DATE|TIME_MINUTES|TIME_SECONDS) 
      + "\n   Broker Time : " + TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS) 
   + "\n   Local Time : " + TimeToStr(TimeLocal(), TIME_DATE|TIME_MINUTES|TIME_SECONDS);
   return (MathRound(readabletime / 3600.0));
}

string DecodeTime(int a0, int a1, int a2, int a3, int a4, int a5) {
   string months = a1 + 100;
   months = StringSubstr(months, 1);
   string years = a2 + 100;
   years = StringSubstr(years, 1);
   string hours = a3 + 100;
   hours = StringSubstr(hours, 1);
   string minutes = a4 + 100;
   minutes = StringSubstr(minutes, 1);
   string seconds = a5 + 100;
   seconds = StringSubstr(seconds, 1);
   return (StringConcatenate(a0, ".", months, ".", years, " ", hours, ":", minutes, ":", seconds));
}

void Indicators() {
   HideTestIndicators(TRUE);
   closem15 = iClose(NULL, PERIOD_M15, 1);
   smmam15 = iMA(NULL, PERIOD_M15, SMMAPeriod, 0, MODE_SMMA, PRICE_CLOSE, 1);
   wprm15 = iWPR(NULL, PERIOD_M15, WPRPeriod, 1);
   atrh1 = iATR(NULL, PERIOD_H1, ATRPeriod, 1);
   emah1 = iMA(NULL, PERIOD_H1, EMAPeriod, 0, MODE_EMA, PRICE_CLOSE, 1);
   closem5 = iClose(NULL, PERIOD_M5, 1);
   prepare_indicators(emah1, atrh1);
   HideTestIndicators(FALSE);
}

void GetBrokerInfos() {
   if (ForceBrokerInfos) {
      ForceBrokerInfos = FALSE;
      brokerminlot = MarketInfo(Symbol(), MODE_MINLOT);
      brokermaxlot = MarketInfo(Symbol(), MODE_MAXLOT);
      brokerleverage = AccountLeverage();
      brokerlotsize = MarketInfo(Symbol(), MODE_LOTSIZE);
      brokerstoplevel = MarketInfo(Symbol(), MODE_STOPLEVEL);
      brokerlotstep = MarketInfo(Symbol(), MODE_LOTSTEP);
   }
   if (DoublingTrade != TRUE) {
      LotMultiplierFF = 1;
      LotMultiplierSF = 1;
   }
}

void CalculateMinimumSLTP() {
   if (Digits <= 3) pipvalue = 0.01;
   else pipvalue = 0.0001;
   if (Ask - Bid > MaxSPREAD * pipvalue) {
      Comment("\n SPREAD IS TOO HIGH ...");
      Print("SPREAD IS TOO HIGH ...");
      return;
   }
   if (TakeProfit < brokerstoplevel * pipvalue) TakeProfit = brokerstoplevel * pipvalue;
   if (TakeProfit2 < brokerstoplevel * pipvalue) TakeProfit2 = brokerstoplevel * pipvalue;
   if (StopLoss < brokerstoplevel * pipvalue) StopLoss = brokerstoplevel * pipvalue;
   if (StopLoss2 < brokerstoplevel * pipvalue) StopLoss2 = brokerstoplevel * pipvalue;
}

void CheckLastOrder() {
   double orderprofit = 0;
   bool lose = FALSE;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) Print("OrderSelect Error! Position:", i);
      else {
         if (OrderType() <= OP_SELL && OrderSymbol() == Symbol())
            if (OrderMagicNumber() == MagicFirst) return;
      }
   }
   for (i = OrdersHistoryTotal() - 1; i >= 0; i--) {
      if (!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) Print("OrderSelect Error! Position:", i);
      else {
         if (OrderType() <= OP_SELL && OrderSymbol() == Symbol()) {
            if (OrderMagicNumber() == MagicFirst) {
               if (OrderType() == OP_BUY) orderprofit = OrderTakeProfit() - OrderClosePrice();
               else orderprofit = OrderClosePrice() - OrderTakeProfit();
               if (orderprofit <= 0.0) {
                  lose = TRUE;
                  break;
               }
            }
         }
      }
   }
   if (!lose) {
      for (i = OrdersTotal() - 1; i >= 0; i--) {
         if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) Print("OrderSelect Error! Position:", i);
         else {
            if (OrderType() <= OP_SELL && OrderSymbol() == Symbol()) {
               if (OrderMagicNumber() == MagicSecond) {
                  if (OrderType() == OP_BUY) {
                     RefreshRates();
                     if (!OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), Slippage, Violet)) Print("Failed to close second face order" + OrderTicket());
                     else Print("Second face order " + OrderTicket() + " was closed due to fisrt face order");
                  }
                  if (OrderType() == OP_SELL) {
                     RefreshRates();
                     if (!OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), Slippage, Violet)) {
                        Print("Failed to close second face order" + OrderTicket());
                        continue;
                     }
                     Print("Second face order " + OrderTicket() + " was closed due to fisrt face order");
                  }
               }
            }
         }
      }
   }
}

void SelectOrders() {
   double stoplossfirst;
   double takeprofitfirst;
   double stoplosssecond;
   double takeprofitsecond;
   int ticketfirst;
   int ticketsecond;
   int datetimefirst = -1;
   int datetimesecond = -1;
   int ordertypefirst = 1;
   int ordertypesecond = 2;
   for (int i = OrdersTotal() - 1; i >= 0; i--) {
      if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) Print("OrderSelect Error! Position:", i);
      else {
         if (OrderType() <= OP_SELL && OrderSymbol() == Symbol()) {
            if (OrderMagicNumber() == MagicFirst) {
               datetimefirst = OrderOpenTime();
               stoplossfirst = OrderStopLoss();
               takeprofitfirst = OrderTakeProfit();
               ticketfirst = OrderTicket();
               ordertypefirst = OrderType();
            }
            if (OrderMagicNumber() == MagicSecond) {
               datetimesecond = OrderOpenTime();
               stoplosssecond = OrderStopLoss();
               takeprofitsecond = OrderTakeProfit();
               ticketsecond = OrderTicket();
               ordertypesecond = OrderType();
            }
         }
      }
   }
   if (datetimesecond < 0) ticketcopy = -1;
   if (ticketcopy == -1) {
      if (ordertypefirst == ordertypesecond && datetimesecond > 0 && datetimefirst > 0 && datetimesecond < datetimefirst) {
         if (MathAbs(stoplossfirst - stoplosssecond) > Point && MathAbs(takeprofitfirst - takeprofitsecond) > Point && stoplossfirst > Point || takeprofitfirst > Point) {
            if (!OrderModify(ticketsecond, 0, stoplossfirst, takeprofitfirst, 0, Red)) Print("Failed to put values of StopLoss and TakeProfit from first to second face for order " + ticketsecond);
            else {
               Print("Values of StopLoss and TakeProfit successfully copied from first to second face for order " + ticketsecond);
               ticketcopy = ticketsecond;
            }
         }
      }
   }
}

int prepare_indicators(double a0, double a1)
{
    calcone = a1 * 1.4 + a0;
    calctwo = a0 - a1 * 1.4;
    return (0);
}
double cond1(double a0)
{
   return (13.0 * a0 + calcone);
}
double cond2(double a0)
{
   return (calctwo - 13.0 * a0);
}
int CheckTarget(int a0, double a1, int a2, double a3, double a4, double a5)
{
  int result = 1;
  if ( a2 <= 0 || a1 <= 0.0 || a0 || a2 * a5 + a3 <= a1 )
  {
    if ( a2 > 0 && a1 > 0.0 && a0 == 1 && a4 - a2 * a5 < a1 )
      result = 0;
  }
  else
  {
    result = 0;
  }
  return (result);
}
int CheckStop(int a0, double a1, int a2, double a3, double a4, double a5)
{
  int result = 1;
  if ( a2 <= 0 || a1 <= 0.0 || a0 || a3 - a2 * a5 >= a1 )
  {
    if ( a2 > 0 && a1 > 0.0 && a0 == 1 && a2 * a5 + a4 > a1 )
      result = 0;
  }
  else
  {
    result = 0;
  }
  return (result);
}