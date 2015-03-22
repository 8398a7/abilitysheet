class API < Grape::API
  mount V22::ScoreViewer
  mount V22::Developer
end
