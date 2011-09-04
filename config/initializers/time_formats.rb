Date::DATE_FORMATS[:month_and_year] = "%B %Y"
Date::DATE_FORMATS[:short_ordinal] = lambda { |date| date.strftime("%B #{date.day.ordinalize}") }
Time::DATE_FORMATS[:jqueryui]  = lambda {|time| time.strftime("%a, %d %b %Y")}
Time::DATE_FORMATS[:custom_short]  = lambda {|time| time.strftime("%a, %b #{time.day.ordinalize}")}
Time::DATE_FORMATS[:day_month_year]  = lambda {|time| time.strftime("%d-%m-%Y")}
Time::DATE_FORMATS[:month_day_time]  = lambda {|time| time.strftime("%b %d at %I:%M%p")}

