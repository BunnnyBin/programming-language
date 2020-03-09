-- Synchronous producer consumer using Rendezvous

with Ada.Text_IO;
use Ada.Text_IO;

procedure ProducerConsumer is
   task Buf_Task is
      entry Deposit(Item: in Integer);
      entry Fetch(Item: out Integer);
   end Buf_Task;

   task body Buf_Task is
      Bufsize: constant Integer := 5;
      Buf: array (1..Bufsize) of Integer;
      Filled: Integer range 0..Bufsize := 0;
      Next_In, Next_Out: Integer range 1..Bufsize := 1;
   begin
      loop
         select
            when Filled < Bufsize =>
               accept Deposit(Item: in Integer) do
                  Buf(Next_In) := Item;
                  Next_In := (Next_In mod Bufsize) + 1;
                  Filled := Filled + 1;
               end Deposit;
         or
            when Filled > 0 =>
               accept Fetch(Item: out Integer) do
                  Item := Buf(Next_Out);
                  Next_Out := (Next_Out mod Bufsize) + 1;
                  Filled := Filled - 1;
               end Fetch;
         end select;
      end loop;
   end Buf_Task;
  
   task Producer;
   task Consumer;

   task body Producer is
      MaxData: constant Integer := 100;
   begin
      for New_Value in 1..MaxData loop
         Put_Line("Producer>" & Integer'Image(New_Value));
         Buf_Task.Deposit(New_Value);
         Put_Line("Producer<" & Integer'Image(New_Value));
      end loop;
   end Producer;

   task body Consumer is
      Stored_Value: Integer;
   begin
      loop
         Buf_Task.Fetch(Stored_Value);
         Put_Line("Consumer=" & Integer'Image(Stored_Value));
      end loop;
   end Consumer;

begin
   null;
end ProducerConsumer;
