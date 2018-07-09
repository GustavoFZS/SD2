this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'rpcmodel_services_pb'

class Aula
	attr_accessor :curso, :professor
	
	def initialize(curso, professor)
		@curso = curso
		@professor = professor
	end
	
	def getJson
		{'curso': curso.to_s, 'professor': professor.nome.to_s}
	end
end

class Professor
	attr_accessor :nome
	
	def initialize(nome)
		@nome = nome
	end
end

class Sala
	attr_accessor :aulas, :alunos
	
	def initialize(aulas, alunos)
		@alunos = alunos
		@aulas = aulas
	end
	
	def getJson
		json = {}
		aulasJson = {}
		aulas.each_with_index do |aula, i|
			aulasJson[i.to_s] = aulasJson[i.to_s].nil? ? aula.getJson() : aulasJson[i.to_s].merge(aula.getJson())
		end
		alunosJson = {}
		alunos.each_with_index do |aluno, i|
			alunosJson[i.to_s] = alunosJson[i.to_s].nil? ? aluno.getJson() : alunosJson[i.to_s].merge(aluno.getJson())
		end
		json['aulas'] = aulasJson
		json['alunos'] = alunosJson
		json
	end
end

class Aluno
	attr_accessor :nome, :aulas
	
	def initialize(nome, aulas)
		@nome = nome
		@aulas = aulas
	end
	
	def getJson
		json = {'nome': nome.to_s}
		aulasJson = {}
		aulas.each_with_index  do |aula, i|
			aulasJson[i.to_s] = aulasJson[i.to_s].nil? ? aula.getJson() : aulasJson[i.to_s].merge(aula.getJson())
		end
		json['aulas'] = aulasJson
		json
	end
end

def main

	puts 'Enviando requisições...'
	rodadas = 1	
	
	tempoTotal = Time.now
	n = 0
	while (n < 10)  do
		n = n + 1
		i = 0
		tempo_final = 0
		while (i < rodadas)  do
			tempo = Time.now
			call1()
			tempo_final = tempo_final + (Time.now - tempo)
			i = i + 1
		end
		puts '1 ' + (tempo_final).to_s

		i = 0
		tempo_final = 0
		while (i < rodadas)  do
			tempo = Time.now
			call2()
			tempo_final = tempo_final + (Time.now - tempo)
			i = i + 1
		end
		puts '2 ' + (tempo_final).to_s

		i = 0
		tempo_final = 0
		while (i < rodadas)  do
			tempo = Time.now
			call3()
			tempo_final = tempo_final + (Time.now - tempo)
			i = i + 1
		end
		puts '3 ' + (tempo_final).to_s

		j = 0
		while(j < 18)
			msg = "0"*(2**j)
			i = 0
			tempo_final = 0
			while (i < rodadas)  do
				tempo = Time.now
				call4(msg)
				tempo_final = tempo_final + (Time.now - tempo)
				i = i + 1
			end
			puts '4 ' + (tempo_final).to_s
			j = j + 1
		end

		professores = [Professor.new('Daniel'), Professor.new('Karla'), Professor.new('Edmir')]
		aulas = [Aula.new('Sistemas Distribuidos', professores[0]), Aula.new('Matematica discreta', professores[1]), Aula.new('Economia', professores[2])]
		alunos = [Aluno.new('Japeto', [aulas[0], aulas[1], aulas[2]]), Aluno.new('Jesus', [aulas[2]]), Aluno.new('Alex', [aulas[0], aulas[1]])]
		sala = Sala.new(aulas, alunos).getJson().to_s

		i = 0
		tempo_final = 0
		while (i < rodadas)  do
			tempo = Time.now
			call5(sala)
			tempo_final = tempo_final + (Time.now - tempo)
			i = i + 1
		end
		puts '5 ' + (tempo_final).to_s
	end

	tempoTotal = Time.now - tempoTotal
	puts 'Requisições enviadas '
	puts 'Final: ' + tempoTotal.to_s
end

def call1()
  stub = Rpcm::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)
  message = stub.metodo1(Rpcm::Metodo1Request.new())
end

def call2()
  stub = Rpcm::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)	
  message = stub.metodo2(Rpcm::Metodo2Request.new(value: 12.12)).message
end

def call3()
  stub = Rpcm::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)
  message = stub.metodo3(Rpcm::Metodo3Request.new(value1: 0, value2: 1, value3: 2, value4: 3, value5: 5, value6: 8, value7: 12, value8: 20)).message
end

def call4(msg)
  stub = Rpcm::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)
  message = stub.metodo4(Rpcm::Metodo4Request.new(text: msg)).message
end

def call5(sala)
  stub = Rpcm::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)
  message = stub.metodo5(Rpcm::Metodo5Request.new({object: sala})).message
end

main

