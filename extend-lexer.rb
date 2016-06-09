require 'rouge'
module Rouge
  module Lexers
    class JSONObject < Rouge::Lexers::HTTP
      tag 'json-object'
    end
    class PHPSDK < Rouge::Lexers::PHP
      tag 'php-sdk'
    end
  end
end
