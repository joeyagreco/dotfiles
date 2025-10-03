return {
    "camspiers/snap",
    config = function()
        -- Basic example config
        local snap = require("snap")
        snap.maps({
            { "<Leader><Leader>", snap.config.file({ producer = "ripgrep.file" }) },
        })
    end,
}
