import 'libraries/noble/Noble'

import 'utilities/Utilities'

import 'scenes/ExampleScene'
import 'scenes/ExampleScene2'
import 'scenes/CrawlerScene'

Noble.Settings.setup({
	Difficulty = "Medium"
})

Noble.GameData.setup({
	Score = 0
})

Noble.showFPS = true

Noble.new(CrawlerScene)
