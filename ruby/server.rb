this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'rpcmodel_services_pb'

class Server <  Rpcm::Greeter::Service
  
  def metodo1(rpc_req, _unused_cal)
    #puts 'Método 1 foi executado.'
	return Rpcm::Metodo1Reply.new()
  end

  def metodo2(rpc_req, _unused_call)
    #puts 'Método 2 foi executado.'
    return Rpcm::Metodo2Reply.new(message:  "#{rpc_req.value.to_f}")
  end

  def metodo3(rpc_req, _unused_call)
    #puts 'Método 3 foi executado.'
    return Rpcm::Metodo3Reply.new(message: "#{rpc_req.value6.to_f}")
  end

  def metodo4(rpc_req, _unused_call)
    #puts 'Método 4 foi executado.'
    return Rpcm::Metodo4Reply.new(message: "#{rpc_req.text}")
  end
  
  def metodo5(rpc_req, _unused_call)
    #puts 'Método 5 foi executado.'
    return Rpcm::Metodo5Reply.new(message: "#{rpc_req.object}")
  end
  
end

def main
  s = GRPC::RpcServer.new
  s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  s.handle(Server)
  s.run_till_terminated
end

main
