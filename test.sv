
///////////////////////////////////
// Módulo para correr la prueba  //
///////////////////////////////////
class test #(parameter width = 16, parameter depth =8); 
  
  comando_test_sb_mbx    test_sb_mbx;
  comando_test_agent_mbx  test_agent_mbx;

  parameter num_transacciones =10;
  parameter max_retardo = 4;
  solicitud_sb orden;
  instrucciones_agente_pkg #(.width(width)) instr_agent;
  solicitud_sb instr_sb;
   
 // Definición del ambiente de la prueba
  ambiente #(.depth(depth),.width(width)) ambiente_inst;
 // Definición de la interface a la que se conectará el DUT
  virtual fifo_if  #(.width(width)) _if;

  //definción de las condiciones iniciales del test
  function new; 
    // instaciación de los mailboxes
    test_sb_mbx  = new();
    test_agent_mbx = new();
    // Definición y conexión del dirver
    ambiente_inst = new();
    ambiente_inst._if = _if;    
    ambiente_inst.test_sb_mbx = test_sb_mbx;
    ambiente_inst.scoreboard_inst.test_sb_mbx = test_sb_mbx;
    ambiente_inst.test_agent_mbx = test_agent_mbx;
    ambiente_inst.agent_inst.test_agent_mbx = test_agent_mbx;
    ambiente_inst.agent_inst.num_transacciones = num_transacciones;
    ambiente_inst.agent_inst.max_retardo = max_retardo;
  endfunction

  task run;
    $display("[%g]  El Test fue inicializado",$time);
    fork
      ambiente_inst.run();
    join_none
    instr_agent = new();
    
    instr_agent.ret_spec = 3;
    instr_agent.tipo_instruccion = trans_especifica;
    instr_agent.dto_spec = {width/4{4'h5}};
    instr_agent.tpo_spec = escritura;
    test_agent_mbx.put(instr_agent);
    $display("[%g]  Test: Enviada la tercera instruccion al agente transaccion_específica",$time);


    instr_agent.ret_spec = 8;
    instr_agent.tipo_instruccion = trans_especifica;
    instr_agent.dto_spec = 16'hA;
    instr_agent.tpo_spec = escritura;
    test_agent_mbx.put(instr_agent);
    $display("[%g]  Test: Enviada la tercera instruccion al agente transaccion_específica",$time);

    instr_agent.ret_spec = 10;
    instr_agent.tipo_instruccion = trans_especifica;
    instr_agent.dto_spec = 16'hFF;
    instr_agent.tpo_spec = escritura;
    test_agent_mbx.put(instr_agent);
    $display("[%g]  Test: Enviada la tercera instruccion al agente transaccion_específica",$time);

    instr_agent.ret_spec = 10;
    instr_agent.tipo_instruccion = trans_especifica;
    instr_agent.dto_spec = 16'hFF;
    instr_agent.tpo_spec = lectura;
    test_agent_mbx.put(instr_agent);
    $display("[%g]  Test: Enviada la tercera instruccion al agente transaccion_específica",$time);

    #10000
    $display("[%g]  Test: Se alcanza el tiempo límite de la prueba",$time);
    instr_sb = retardo_promedio;
    test_sb_mbx.put(instr_sb);
    instr_sb = reporte;
    test_sb_mbx.put(instr_sb);
    #20
    $finish;
  endtask
endclass 
