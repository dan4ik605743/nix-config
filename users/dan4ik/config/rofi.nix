{ colors }:

with colors;

''
  * {
      active-background: ${color4};
      active-foreground: @foreground;
      normal-background: @background;
      normal-foreground: @foreground;
      urgent-background: ${color4};
      urgent-foreground: @foreground;

      alternate-active-background: @background;
      alternate-active-foreground: @foreground;
      alternate-normal-background: @background;
      alternate-normal-foreground: @foreground;
      alternate-urgent-background: @background;
      alternate-urgent-foreground: @foreground;

      selected-active-background: ${color4};
      selected-active-foreground: @foreground;
      selected-normal-background: ${color4};
      selected-normal-foreground: @foreground;
      selected-urgent-background: ${color4};
      selected-urgent-foreground: @foreground;

      background-color: @background;
      background: ${background};
      foreground: ${foreground};
      border-color: @background;
      spacing: 2;
  }

  #window {
      background-color: @background;
      border: 0;
      padding: 2.5ch;
  }

  #mainbox {
      border: 0;
      padding: 0;
  }

  #message {
      border: 2px 0px 0px;
      border-color: @border-color;
      padding: 1px;
  }

  #textbox {
      text-color: @foreground;
  }

  #inputbar {
      children:   [ prompt,textbox-prompt-colon,entry,case-indicator ];
  }

  #textbox-prompt-colon {
      expand: false;
      str: "";
      margin: 0px 0.3em 0em 0em;
      text-color: @normal-foreground;
  }

  #listview {
      fixed-height: 0;
      border: 2px 0px 0px;
      border-color: @border-color;
      spacing: 2px;
      scrollbar: true;
      padding: 2px 0px 0px;
  }

  #element {
      border: 0;
      padding: 1px;
  }

  #element.normal.normal {
      background-color: @normal-background;
      text-color: @normal-foreground;
  }

  #element.normal.urgent {
      background-color: @urgent-background;
      text-color: @urgent-foreground;
  }

  #element.normal.active {
      background-color: @active-background;
      text-color: @active-foreground;
  }

  #element.selected.normal {
      background-color: @selected-normal-background;
      text-color: @selected-normal-foreground;
  }

  #element.selected.urgent {
      background-color: @selected-urgent-background;
      text-color: @selected-urgent-foreground;
  }

  #element.selected.active {
      background-color: @selected-active-background;
      text-color: @selected-active-foreground;
  }

  #element.alternate.normal {
      background-color: @alternate-normal-background;
      text-color: @alternate-normal-foreground;
  }

  #element.alternate.urgent {
      background-color: @alternate-urgent-background;
      text-color: @alternate-urgent-foreground;
  }

  #element.alternate.active {
      background-color: @alternate-active-background;
      text-color: @alternate-active-foreground;
  }

  #scrollbar {
      width: 4px;
      border: 0;
      handle-width: 8px;
      padding: 0;
  }

  #sidebar {
      border: 2px 0px 0px;
      border-color: @border-color;
  }

  #button {
      text-color: @normal-foreground;
  }

  #button.selected {
      background-color: @selected-normal-background;
      text-color: @selected-normal-foreground;
  }

  #inputbar {
      spacing: 0;
      text-color: @normal-foreground;
      padding: 1px;
  }

  #case-indicator {
      spacing: 0;
      text-color: @normal-foreground;
  }

  #entry {
      spacing: 0;
      text-color: @normal-foreground;
  }

  #prompt {
      spacing: 0;
      text-color: @normal-foreground;
  }
''
