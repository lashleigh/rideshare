module HomeHelper
  def start_date_array
    [["Use exact date above", "exact"], 
      ["1 day before",           "onebefore"], 
      ["1 day after",            "oneafter"], 
      ["1 day before and after", "one"], 
      ["2 days before and after","two"], 
      ["3 days before and after","three"]]
  end
  def create_options(val)
    val = "25" unless radius_array.map{|a,b| b}.include? val
    radius_array.map{|a,b| [a,b,b==val ? "selected='selected'" : ""]}
          .map{|a,b,c| "<option value=#{b} #{c}>#{a}</option>"}.join.html_safe
  end
  def radius_array
    [ ["< 10 mi", "10"], 
      ["< 15 mi", "15"],
      ["< 25 mi", "25"],
      ["< 35 mi", "35"],
      ["< 50 mi", "50"]]
  end
end
