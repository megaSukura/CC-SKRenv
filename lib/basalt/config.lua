return {
  ["categories"] = {
    ["core"] = {
      ["description"] = "Core Files",
      ["files"] = {
        ["main"] = {
          ["path"] = "main.lua",
          ["default"] = true,
          ["size"] = 10456,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["elementManager"] = {
          ["path"] = "elementManager.lua",
          ["default"] = true,
          ["size"] = 6297,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["propertySystem"] = {
          ["path"] = "propertySystem.lua",
          ["default"] = true,
          ["size"] = 15524,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["render"] = {
          ["path"] = "render.lua",
          ["default"] = true,
          ["size"] = 12422,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["errorManager"] = {
          ["path"] = "errorManager.lua",
          ["default"] = true,
          ["size"] = 3789,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["log"] = {
          ["path"] = "log.lua",
          ["default"] = true,
          ["size"] = 3142,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["init"] = {
          ["path"] = "init.lua",
          ["default"] = true,
          ["size"] = 583,
          ["description"] = "",
          ["requires"] = {
          },
        },
      },
    },
    ["plugins"] = {
      ["description"] = "Plugins",
      ["files"] = {
        ["animation"] = {
          ["path"] = "plugins/animation.lua",
          ["default"] = true,
          ["size"] = 14731,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["debug"] = {
          ["path"] = "plugins/debug.lua",
          ["default"] = true,
          ["size"] = 6250,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["state"] = {
          ["path"] = "plugins/state.lua",
          ["default"] = true,
          ["size"] = 6896,
          ["description"] = "",
          ["requires"] = {
            [1] = "Container",
          },
        },
        ["canvas"] = {
          ["path"] = "plugins/canvas.lua",
          ["default"] = true,
          ["size"] = 7873,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["reactive"] = {
          ["path"] = "plugins/reactive.lua",
          ["default"] = true,
          ["size"] = 7193,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["xml"] = {
          ["path"] = "plugins/xml.lua",
          ["default"] = true,
          ["size"] = 9901,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["benchmark"] = {
          ["path"] = "plugins/benchmark.lua",
          ["default"] = true,
          ["size"] = 12581,
          ["description"] = "",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["theme"] = {
          ["path"] = "plugins/theme.lua",
          ["default"] = true,
          ["size"] = 7166,
          ["description"] = "",
          ["requires"] = {
          },
        },
      },
    },
    ["libraries"] = {
      ["description"] = "Libraries",
      ["files"] = {
        ["colorHex"] = {
          ["path"] = "libraries/colorHex.lua",
          ["default"] = true,
          ["size"] = 132,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["expect"] = {
          ["path"] = "libraries/expect.lua",
          ["default"] = true,
          ["size"] = 846,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["utils"] = {
          ["path"] = "libraries/utils.lua",
          ["default"] = true,
          ["size"] = 2661,
          ["description"] = "",
          ["requires"] = {
          },
        },
      },
    },
    ["elements"] = {
      ["description"] = "UI Elements",
      ["files"] = {
        ["List"] = {
          ["path"] = "elements/List.lua",
          ["default"] = true,
          ["size"] = 8702,
          ["description"] = "A scrollable list of selectable items",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["Switch"] = {
          ["path"] = "elements/Switch.lua",
          ["default"] = true,
          ["size"] = 1378,
          ["description"] = "",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["Frame"] = {
          ["path"] = "elements/Frame.lua",
          ["default"] = true,
          ["size"] = 4458,
          ["description"] = "A frame element that serves as a grouping container for other elements.",
          ["requires"] = {
            [1] = "Container",
          },
        },
        ["TextBox"] = {
          ["path"] = "elements/TextBox.lua",
          ["default"] = false,
          ["size"] = 10929,
          ["description"] = "A multi-line text editor component with cursor support and text manipulation features",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["VisualElement"] = {
          ["path"] = "elements/VisualElement.lua",
          ["default"] = true,
          ["size"] = 17775,
          ["description"] = "The Visual Element class which is the base class for all visual UI elements",
          ["requires"] = {
            [1] = "BaseElement",
          },
        },
        ["Label"] = {
          ["path"] = "elements/Label.lua",
          ["default"] = true,
          ["size"] = 3092,
          ["description"] = "A simple text display element that automatically resizes its width based on the text content.",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["BaseFrame"] = {
          ["path"] = "elements/BaseFrame.lua",
          ["default"] = true,
          ["size"] = 8466,
          ["description"] = "This is the base frame class. It is the root element of all elements and the only element without a parent.",
          ["requires"] = {
            [1] = "Container",
          },
        },
        ["Flexbox"] = {
          ["path"] = "elements/Flexbox.lua",
          ["default"] = true,
          ["size"] = 12215,
          ["description"] = "A flexbox container that arranges its children in a flexible layout.",
          ["requires"] = {
            [1] = "Container",
          },
        },
        ["Input"] = {
          ["path"] = "elements/Input.lua",
          ["default"] = true,
          ["size"] = 8876,
          ["description"] = "A text input field with various features",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["Container"] = {
          ["path"] = "elements/Container.lua",
          ["default"] = true,
          ["size"] = 25030,
          ["description"] = "The container class. It is a visual element that can contain other elements. It is the base class for all containers",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["Tree"] = {
          ["path"] = "elements/Tree.lua",
          ["default"] = true,
          ["size"] = 7941,
          ["description"] = "",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["Slider"] = {
          ["path"] = "elements/Slider.lua",
          ["default"] = true,
          ["size"] = 4766,
          ["description"] = "",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["Image"] = {
          ["path"] = "elements/Image.lua",
          ["default"] = false,
          ["size"] = 15125,
          ["description"] = "An element that displays an image in bimg format",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["Graph"] = {
          ["path"] = "elements/Graph.lua",
          ["default"] = false,
          ["size"] = 6990,
          ["description"] = "A point based graph element",
          ["requires"] = {
          },
        },
        ["ProgressBar"] = {
          ["path"] = "elements/ProgressBar.lua",
          ["default"] = true,
          ["size"] = 3397,
          ["description"] = "",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["BigFont"] = {
          ["path"] = "elements/BigFont.lua",
          ["default"] = false,
          ["size"] = 20951,
          ["description"] = "",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["Program"] = {
          ["path"] = "elements/Program.lua",
          ["default"] = true,
          ["size"] = 7733,
          ["description"] = "",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["BaseElement"] = {
          ["path"] = "elements/BaseElement.lua",
          ["default"] = true,
          ["size"] = 9544,
          ["description"] = "The base class for all UI elements in Basalt.",
          ["requires"] = {
          },
        },
        ["Dropdown"] = {
          ["path"] = "elements/Dropdown.lua",
          ["default"] = false,
          ["size"] = 6359,
          ["description"] = "A dropdown menu that shows a list of selectable items",
          ["requires"] = {
            [1] = "List",
          },
        },
        ["Button"] = {
          ["path"] = "elements/Button.lua",
          ["default"] = true,
          ["size"] = 1656,
          ["description"] = "",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["Checkbox"] = {
          ["path"] = "elements/Checkbox.lua",
          ["default"] = true,
          ["size"] = 2928,
          ["description"] = "",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["BarChart"] = {
          ["path"] = "elements/BarChart.lua",
          ["default"] = false,
          ["size"] = 3190,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["Display"] = {
          ["path"] = "elements/Display.lua",
          ["default"] = false,
          ["size"] = 4243,
          ["description"] = "The Display is a special element which uses the cc window API which you can use.",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["Menu"] = {
          ["path"] = "elements/Menu.lua",
          ["default"] = true,
          ["size"] = 4679,
          ["description"] = "A horizontal menu bar with selectable items.",
          ["requires"] = {
            [1] = "List",
          },
        },
        ["Scrollbar"] = {
          ["path"] = "elements/Scrollbar.lua",
          ["default"] = true,
          ["size"] = 9191,
          ["description"] = "",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
        ["LineChart"] = {
          ["path"] = "elements/LineChart.lua",
          ["default"] = false,
          ["size"] = 3227,
          ["description"] = "",
          ["requires"] = {
          },
        },
        ["Table"] = {
          ["path"] = "elements/Table.lua",
          ["default"] = true,
          ["size"] = 8680,
          ["description"] = "",
          ["requires"] = {
            [1] = "VisualElement",
          },
        },
      },
    },
  },
  ["metadata"] = {
    ["version"] = "2.0",
    ["generated"] = "Sat Apr 19 07:21:46 2025",
  },
}