class @LampStatistics extends React.Component
  constructor: (props) ->
    super

  render: ->
    <div className='uk-overflow-container'>
      <table className='uk-table uk-table-bordered' style={align: 'center'}>
        <tbody>
          <tr>
            <td style={backgroundColor: '#ff8c00'}>FC</td>
            <td className='statistics' id='fc' />
            <td style={backgroundColor: '#ffd900'}>EXH</td>
            <td className='statistics' id='exh' />
            <td style={backgroundColor: '#ff6347'}>H</td>
            <td className='statistics' id='h' />
            <td style={backgroundColor: '#afeeee'}>C</td>
            <td className='statistics' id='c' />
            <td style={backgroundColor: '#98fb98'}>E</td>
            <td className='statistics' id='e' />
            <td style={backgroundColor: '#9595ff'}>A</td>
            <td className='statistics' id='a' />
            <td style={backgroundColor: '#c0c0c0'}>F</td>
            <td className='statistics' id='f' />
            <td style={backgroundColor: '#ffffff'}>N</td>
            <td className='statistics' id='n' />
            <td id='per' style={backgroundColor: '#7fffd4'} />
          </tr>
        </tbody>
      </table>
    </div>
