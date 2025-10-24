import './App.css'
import LoginForm from './components/Forms/LoginForm'
import RegisterForm from './components/Forms/RegisterForm'
import ForgotPasswordForm1 from './components/Forms/ForgotPasswordForm1'
import ForgotPasswordForm2 from './components/Forms/ForgotPasswordForm2'
import { useState } from 'react'

function App() {
	const [currentFormState, setCurrentFormState] = useState('login')

	return (
		<>
			<div className='title-container'>
				<h1>Welcome to <span>E'Shop</span>!</h1>
			</div>
			<div className='main-container'>
				<img style={{zIndex: 2, marginRight: -20}} src="src/assets/picture.svg"/>
				{currentFormState === 'login' &&
					<LoginForm setCurrentFormState={setCurrentFormState}/>
				}
				{currentFormState === 'register' &&
					<RegisterForm setCurrentFormState={setCurrentFormState}/>
				}
				{currentFormState === 'forgot1' &&
					<ForgotPasswordForm1 setCurrentFormState={setCurrentFormState}/>
				}
				{currentFormState === 'forgot2' &&
					<ForgotPasswordForm2 setCurrentFormState={setCurrentFormState}/>
				}
			</div>
		</>
	)
}

export default App
