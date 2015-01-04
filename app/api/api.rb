class API < Grape::API
  mount V22::ScoreViewer
end
