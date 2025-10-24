import { useForm } from "react-hook-form"
import InputField from "../InputField/InputField"
import * as yup from "yup"
import { yupResolver } from "@hookform/resolvers/yup"

const schema = yup.object({
	email: yup.string().required("Email is required").email("Email not correct"),
	password: yup.string().required("Password is required").min(6, "Password not valid"),
})

const LoginForm = ({setCurrentFormState}) => {
	const {
		register,
		handleSubmit,
		reset,
		formState: {
			errors,
		},
	} = useForm({
		mode: "all",
		resolver: yupResolver(schema),
	})

	const onSubmit = (data) => {

		//localStorage.setItem("password", data.password)
		if (localStorage.getItem("password") === data.password) {
			reset()
			alert("Success!")
		} else {
			alert("Wrong password!")
		}
	}

	return (
		<div className="form-container">
			<h1>Sign In</h1>
			<form className="form" onSubmit={handleSubmit(onSubmit)}>
				<InputField
					labelValue="Email:"
					inputType="text"
					register={register}
					value="email"
					placeholder="Email"
					errorMessage={errors.email?.message}
				/>
				<InputField
					labelValue="Password:"
					inputType="password"
					register={register}
					value="password"
					placeholder="Password"
					errorMessage={errors.password?.message}
				/>
				<input type="submit" className="submit-button" value="Log In"/>
			</form>
			<div className="form-links-holder">
				<a className="form-link-1" onClick={() => setCurrentFormState('register')}>Create Account</a>
				<p>Or</p>
				<a className="form-link-2" onClick={() => setCurrentFormState('forgot1')}>Forgot Password?</a>
			</div>
		</div>
	)
}

export default LoginForm