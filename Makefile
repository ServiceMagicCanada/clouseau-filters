all: build doc

help: 
	
	@echo ""
	@echo "Make Commands:"
	@echo ""
	@echo "- doc:           Reads code comments and writes to the API.md file."
	@echo "- build:         Copies './src/*/' into './lib/*/' and compiles all .coffee in './lib/*/'"
	@echo "- watch:         Watches './src' for changes and automatically runs 'build'"
	@echo "- test:          Runs the tests using nodeunit."
	@echo "- install:       Runs npm install."
	@echo "- destroy:       removes './lib'."
	@echo ""
	
doc: 
	
	@if test -d ./src;\
  	then echo "# Building docs from files in ./src.";\
	  else echo "\n# Please run 'make build' first.\n" && exit 1;\
	fi;	
	@rm -f API.md
	@for x in `ls src/*.coffee`; do \
	 readthis $$x >> API.md;\
	done
	

build: destroy
	
	# Deleting ./lib then getting copy from ./src.	
	@cp -r ./src ./lib
	# Compiling ./lib coffeescripts into their respective destinations.	
	@coffee -cb -o ./lib ./lib		
	
	# Deleting duplicate .coffee files since now we have .js copies
	@for x in `find lib -name "*.coffee"`; do \
		rm $$x;\
	done
	# Adding a noedit notice to generated folders
	@echo "# Development Notice!\n\nThese files are generated, edit source in ./src" | tee ./lib/NOEDIT.md > /dev/null
	
	
watch:
	
	# Watching coffee files to recompile. If you edit package.json files, please exit and run 'make packages'
	@watchr -e 'watch( "src/.*/*\.coffee" ) { |md| system("make build") }'
	

install: 
	
	@npm install
	
destroy: 
	
	# Unmaking bin, lib, filters, and API.md
	@rm -rf ./lib
	@rm -rf ./API.md
	
	
.PHONY: build doc test watch install destroy help
