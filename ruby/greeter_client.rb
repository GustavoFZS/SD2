#!/usr/bin/env ruby

# Copyright 2015 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Sample app that connects to a Greeter service.
#
# Usage: $ path/to/greeter_client.rb

this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'helloworld_services_pb'

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
	rodadas = 1000

	tempo = Time.now
	i = 0
	while (i < rodadas)  do
		call1()
		i = i + 1
	end
	p '1 ' + (Time.now - tempo).to_s

	tempo = Time.now
	i = 0
	while (i < rodadas)  do
		call2()
		i = i + 1
	end
	p '2 ' + (Time.now - tempo).to_s

	i = 0
	while (i < rodadas)  do
		call3()
		i = i + 1
	end
	p '3 ' + (Time.now - tempo).to_s

	j = 0
	while(j < 12)
		msg = "0"*(2**j)
		tempo = Time.now
		i = 0
		while (i < rodadas)  do
			call4(msg)
			i = i + 1
		end
		puts '4 ' + j.to_s + ' ' + (Time.now - tempo).to_s
		j = j + 1
	end

	professores = [Professor.new('Daniel'), Professor.new('Karla'), Professor.new('Edmir')]
	aulas = [Aula.new('Sistemas Distribuidos', professores[0]), Aula.new('Matematica discreta', professores[1]), Aula.new('Economia', professores[2])]
	alunos = [Aluno.new('Japeto', [aulas[0], aulas[1], aulas[2]]), Aluno.new('Jesus', [aulas[2]]), Aluno.new('Alex', [aulas[0], aulas[1]])]
	sala = Sala.new(aulas, alunos).getJson().to_s

	tempo = Time.now
	i = 0
	while (i < rodadas)  do
		call5(sala)
		i = i + 1
	end
	p '5 ' + (Time.now - tempo).to_s
	puts 'Requisições enviadas '

  #p "Greeting: #{message}"
end

def call1()
  stub = Helloworld::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)
  message = stub.metodo1(Helloworld::Metodo1Request.new())
end

def call2()
  stub = Helloworld::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)	
  message = stub.metodo2(Helloworld::Metodo2Request.new(value: 12.12)).message
end

def call3()
  stub = Helloworld::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)
  message = stub.metodo3(Helloworld::Metodo3Request.new(value1: 0, value2: 1, value3: 2, value4: 3, value5: 5, value6: 8, value7: 12, value8: 20)).message
end

def call4(msg)
  stub = Helloworld::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)
  message = stub.metodo4(Helloworld::Metodo4Request.new(text: msg)).message
end

def call5(sala)
  stub = Helloworld::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)
  message = stub.metodo5(Helloworld::Metodo5Request.new({object: sala})).message
end

main

