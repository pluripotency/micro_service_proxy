express = require('express')
router = express.Router()

router.route '/'
.get (req, res)-> res.send 'Hello API'

module.exports = router
