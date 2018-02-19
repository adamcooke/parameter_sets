module ParameterSets
  class Error < StandardError
  end

  class NoParametersPermittedError < Error
  end

  class ParameterSetNotDefinedError < Error
  end
end
