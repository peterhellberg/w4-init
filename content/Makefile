TITLE="w4-zig-cart"
NAME=w4-zig-cart
ARCHIVE=${NAME}.zip
GAME_URL=https://${HOSTNAME}/${NAME}
SERVER_PATH=~/public_html/${NAME}
HOSTNAME=localhost
BACKUP_PATH=/tmp/

all:
	zig build

.PHONY: watch
watch:
	zig build --watch

.PHONY: run
run:
	zig build run

.PHONY: clean
clean:
	rm -rf .zig-cache zig-out bundle

.PHONY: bundle
bundle: all
	@w4 bundle zig-out/bin/cart.wasm --title ${TITLE} --html bundle/${NAME}.html 		# HTML
	@w4 bundle zig-out/bin/cart.wasm --title ${TITLE} --linux bundle/${NAME}.elf 		# Linux (ELF)
	@w4 bundle zig-out/bin/cart.wasm --title ${TITLE} --windows bundle/${NAME}.exe 	# Windows (PE32+)
	@cp zig-out/bin/cart.wasm bundle/${NAME}.wasm
	@zip -juq bundle/${ARCHIVE} bundle/${NAME}.html bundle/${NAME}.elf bundle/${NAME}.exe bundle/${NAME}.wasm
	@echo "✔ Updated bundle/${ARCHIVE}"

.PHONY: backup
backup: bundle
	@mkdir -p ${BACKUP_PATH}/${NAME}
	@cp bundle/${NAME}.* ${BACKUP_PATH}/${NAME}/
	@cp build.zig* ${BACKUP_PATH}/${NAME}/
	@cp -r --no-preserve=mode src ${BACKUP_PATH}/${NAME}/
	@echo "✔ Backed up to ${BACKUP_PATH}/${NAME}"

.PHONY: deploy
deploy: bundle
	@ssh ${HOSTNAME} 'mkdir -p ${SERVER_PATH}'
	@scp -q bundle/${NAME}.html ${HOSTNAME}:${SERVER_PATH}/index.html
	@scp -q bundle/${NAME}.wasm ${HOSTNAME}:${SERVER_PATH}/${NAME}.wasm
	@echo "✔ Updated ${NAME} on ${GAME_URL}"
	@scp -q build.zig* ${HOSTNAME}:${SERVER_PATH}/
	@scp -qr src ${HOSTNAME}:${SERVER_PATH}/
	@echo "✔ Sources ${GAME_URL}/src/"
	@scp -q bundle/${ARCHIVE} ${HOSTNAME}:${SERVER_PATH}/${ARCHIVE}
	@echo "✔ Archive ${GAME_URL}/${ARCHIVE}"
