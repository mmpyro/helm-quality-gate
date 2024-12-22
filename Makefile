SHELL := /bin/bash
k8s_version := 1.30.0
chart := example-app

.PHONY: helm-lint
helm-lint:
	ct lint --config .github/ct-config/config.yaml \
  --lint-conf .github/ct-config/lint.yaml \
  --charts $(chart) --debug

.PHONY: helm-unittests
helm-unittests:
	helm unittest --update-snapshot \
		-f "unit-tests/*.yaml" --output-type JUnit \
		--output-file reports/test-report.xml $(chart)

.PHONY: helm-schematest
helm-schematest:
	helm template $(chart) | kubeconform --summary \
	 --strict -ignore-missing-schemas --kubernetes-version $(k8s_version)
