import {createElement} from 'lwc';
import helloWorld from 'c/helloWorld';
describe('c-hello-world',()=>{
    afterEach(()  => {
        while(document.body.firstChild){
            document.body.removeChild(document.body.firstChild);
        }
    });
    it('displays greeting', ()=>{
        const element=createElement('c-hello-world',{
            is:helloWorld
       });
       document.body.appendChild(element);
       const pTag=element.shadowRoot.querySelector('p');
       expect(pTag.textContent).toBe('Hello,World!');
    });
    it('Renders with Hello Matt',() => {
        const element=createElement('c-hello-world',{
            is:helloWorld
        });
        element.person="Matt";
        document.body.appendChild(element);
        

        const pTag=element.shadowRoot.querySelector('p');
        expect(pTag.textContent).toEqual('Hello,Matt!');
            
        
    });
});