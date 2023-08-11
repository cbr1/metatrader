//+------------------------------------------------------------------+
//|        MoveIndexOrdersToBreakevenWithoutDeletingSL.mq4          |
//|                     Copyright 2023, MetaQuotes Software Corp.    |
//|                                              https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- show input parameters
#property show_inputs
input double BreakevenPips = 0; // Numero di pips per il livello di breakeven

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
   string indexName = SymbolName(Symbol(), true);
   Print("Spostamento a breakeven per l'indice: ", indexName);

   // Cicla attraverso gli ordini aperti
   int totalOrders = OrdersTotal();
   for (int i = 0; i < totalOrders; i++)
     {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if (OrderType() <= OP_SELL && OrderSymbol() == Symbol()) // Solo ordini Buy e Sell per lo stesso strumento
           {
            double openPrice = OrderOpenPrice();
            double breakevenPrice = OrderType() == OP_BUY ? openPrice + BreakevenPips * Point : openPrice - BreakevenPips * Point;

            // Modifica l'ordine a breakeven solo se il prezzo corrente è superiore al prezzo di breakeven per gli ordini Buy,
            // o inferiore al prezzo di breakeven per gli ordini Sell
            if ((OrderType() == OP_BUY && MarketInfo(Symbol(), MODE_ASK)  > breakevenPrice) ||
                (OrderType() == OP_SELL && MarketInfo(Symbol(), MODE_BID) < breakevenPrice))
              {
               Print("Spostamento a breakeven per l'ordine: ", OrderTicket(), " sull'indice: ", indexName);
               OrderModify(OrderTicket(), OrderOpenPrice(), breakevenPrice, OrderTakeProfit(), OrderExpiration(), clrNONE);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+

