//+------------------------------------------------------------------+
//|                                            MonitoringAnother.mq4 |
//|                                          Copyright 2015, jinsong |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, jinsong"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#import "gendan.dll"
int OrderFileOpen(string);
string OrderFileClose();

#import
string             InpFileName="mtorder.csv";       // File name 
string             InpDirectoryName="d:";     // Folder name 


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int file_handle=0;
int OnInit()
  {
   EventSetMillisecondTimer(300);     
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   EventKillTimer(); 
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

//---
      WriteOrderToFile(  CheckOrder()); 
      
  }
int curOrder=0;
int preOrder=0;  
void OnTimer()
  {
//---
   curOrder= PositionsTotal();
   if(curOrder!=preOrder){
      WriteOrderToFile(  CheckOrder()); 
      preOrder=curOrder;   
   }
  }  
//+------------------------------------------------------------------+
void WriteOrderToFile(string str="#"){
   

   ResetLastError(); 


   file_handle=OrderFileOpen(str);

   //printf("%s ,file_handle=%d",str,file_handle);
}
string CheckOrder(){
  string str="#";
   int total=PositionsTotal(); // 持仓数   
   //--- 重做所有持仓
   for(int i=total-1; i>=0; i--)
     {
      ulong  position_ticket=PositionGetTicket(i);                                      // 持仓价格
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // 交易品种 
      int    digits=(int)SymbolInfoInteger(position_symbol,SYMBOL_DIGITS);              // 小数位数
      ulong  magic=PositionGetInteger(POSITION_MAGIC);                                  // 持仓的幻数
      double volume=PositionGetDouble(POSITION_VOLUME);                                 // 持仓交易量
      ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);    // 持仓类型
      
      if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY || PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL ){
         str+=IntegerToString(position_ticket)+",";
         str+=IntegerToString(type)+","; 
         str+=position_symbol+",";             
         str+=DoubleToString(volume)+"#";      
      }
     }


     
  return str;   
}
