INDEX_HTML=index.html
INDEX_EXPANDED=.build/index.expanded.md
CAMPAIGN_HTML=El Pelegrinatge de la Lluna Mossegada - Campanya AoFQ.html
CAMPAIGN_EXPANDED=.build/lluna-mossegada.expanded.md
STRANGER_HTML=Llums en la Foscor - Campanya AoFQ.html
STRANGER_EXPANDED=.build/stranger-things.expanded.md
OMBRES_HTML=Les Ombres de Sant Josep - Campanya Pulp Alley.html
OMBRES_EXPANDED=.build/ombres-sant-josep.expanded.md
TORTUGUES_HTML=Tortugues Ninja - Campanya Pulp Alley.html
TORTUGUES_EXPANDED=.build/tortugues-ninja.expanded.md
TORTUGUES_AOFQ_HTML=Tortugues Ninja - Campanya AoFQ.html
TORTUGUES_AOFQ_EXPANDED=.build/tortugues-ninja-aofq.expanded.md

.PHONY: html index campaign stranger ombres tortugues tortugues-aofq validate expanded

expanded:
	python3 build.py

html: index campaign stranger ombres tortugues tortugues-aofq

index: expanded
	pandoc "$(INDEX_EXPANDED)" --from markdown-smart+raw_html+fenced_divs+bracketed_spans --to html5 --template templates/index.html --standalone -o "$(INDEX_HTML)"

campaign: expanded
	pandoc "$(CAMPAIGN_EXPANDED)" --from markdown-smart+raw_html+fenced_divs+bracketed_spans --to html5 --lua-filter filters/tag-divs.lua --template templates/campanya.html --standalone -o "$(CAMPAIGN_HTML)"

stranger: expanded
	pandoc "$(STRANGER_EXPANDED)" --from markdown-smart+raw_html+fenced_divs+bracketed_spans --to html5 --lua-filter filters/tag-divs.lua --template templates/stranger-things.html --standalone -o "$(STRANGER_HTML)"

ombres: expanded
	pandoc "$(OMBRES_EXPANDED)" --from markdown-smart+raw_html+fenced_divs+bracketed_spans --to html5 --lua-filter filters/tag-divs.lua --template templates/stranger-things.html --standalone -o "$(OMBRES_HTML)"

tortugues: expanded
	pandoc "$(TORTUGUES_EXPANDED)" --from markdown-smart+raw_html+fenced_divs+bracketed_spans --to html5 --lua-filter filters/tag-divs.lua --template templates/tortugues-ninja.html --standalone -o "$(TORTUGUES_HTML)"

tortugues-aofq: expanded
	pandoc "$(TORTUGUES_AOFQ_EXPANDED)" --from markdown-smart+raw_html+fenced_divs+bracketed_spans --to html5 --lua-filter filters/tag-divs.lua --template templates/tortugues-ninja.html --standalone -o "$(TORTUGUES_AOFQ_HTML)"

validate: html
	xmllint --html --noout "$(INDEX_HTML)"
	xmllint --html --noout "$(CAMPAIGN_HTML)"
	xmllint --html --noout "$(STRANGER_HTML)"
	xmllint --html --noout "$(OMBRES_HTML)"
	xmllint --html --noout "$(TORTUGUES_HTML)"
	xmllint --html --noout "$(TORTUGUES_AOFQ_HTML)"
