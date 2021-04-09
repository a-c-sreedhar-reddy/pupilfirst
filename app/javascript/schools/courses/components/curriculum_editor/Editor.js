import React, { Component } from "react";
import { CKEditor } from "@ckeditor/ckeditor5-react";
import "classic-react-with-markdown";

function App({ data, onChange, onReady }) {
  return (
    <div className="App">
      <CKEditor
        editor={ClassicEditor}
        data={data}
        onReady={(editor) => {
          // You can store the "editor" and use when it is needed.
          console.log("Editor is ready to use!", editor);
          onReady(editor.getData());
        }}
        onChange={(event, editor) => {
          const data = editor.getData();
          onChange(data);
          console.log({ event, editor, data });
        }}
        onBlur={(event, editor) => {
          console.log("Blur.", editor);
        }}
        onFocus={(event, editor) => {
          console.log("Focus.", editor);
        }}
      />
    </div>
  );
}

export default App;
