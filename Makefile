run-dev :
	npm run dev

build-prod :
	docker build -f Dockerfile -t 10.0.0.2:81/prod/ct-frontend:latest .
	docker push 10.0.0.2:81/prod/ct-frontend:latest