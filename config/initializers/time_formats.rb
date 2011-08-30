Date::DATE_FORMATS[:month_and_year] = "%B %Y"
Date::DATE_FORMATS[:short_ordinal] = lambda { |date| date.strftime("%B #{date.day.ordinalize}") }
Date::DATE_FORMATS[:jqueryui]      = "%a, %d %b %Y"
Time::DATE_FORMATS[:custom_short]  = lambda {|time| time.strftime("%a %b #{time.day.ordinalize}")}
