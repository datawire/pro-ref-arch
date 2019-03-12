.PHONY: client 

client: client.clean client.build-docker client.build 

client.clean:
	@echo " ---> deleting binaries"
	@rm -rf bin && mkdir bin

client.build-docker:
	@docker build -f $(PWD)/client/Dockerfile -t kat-client-build .	

client.build:	
	@echo " ---> building client"
	@cd client && npm install && npx webpack